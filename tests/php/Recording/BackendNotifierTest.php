<?php
/**
 *
 * @copyright Copyright (c) 2018 Joachim Bauch <bauch@struktur.de>
 * @copyright Copyright (c) 2023 Daniel Calviño Sánchez <danxuliu@gmail.com>
 *
 * @license GNU AGPL version 3 or any later version
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

namespace OCA\Talk\Tests\php\Recording;

use OCA\Talk\Chat\CommentsManager;
use OCA\Talk\Config;
use OCA\Talk\Manager;
use OCA\Talk\Model\AttendeeMapper;
use OCA\Talk\Model\SessionMapper;
use OCA\Talk\Recording\BackendNotifier;
use OCA\Talk\Room;
use OCA\Talk\Service\ParticipantService;
use OCA\Talk\TalkSession;
use OCP\App\IAppManager;
use OCP\AppFramework\Utility\ITimeFactory;
use OCP\EventDispatcher\IEventDispatcher;
use OCP\Http\Client\IClientService;
use OCP\IGroupManager;
use OCP\IL10N;
use OCP\IURLGenerator;
use OCP\IUserManager;
use OCP\Security\IHasher;
use OCP\Security\ISecureRandom;
use PHPUnit\Framework\MockObject\MockObject;
use Psr\Log\LoggerInterface;
use Test\TestCase;

class CustomBackendNotifier extends BackendNotifier {
	private array $requests = [];

	public function getRequests(): array {
		return $this->requests;
	}

	public function clearRequests() {
		$this->requests = [];
	}

	protected function doRequest(string $url, array $params, int $retries = 3): void {
		$this->requests[] = [
			'url' => $url,
			'params' => $params,
		];
	}
}

/**
 * @group DB
 */
class BackendNotifierTest extends TestCase {
	private ?Config $config = null;
	private ?ISecureRandom $secureRandom = null;
	/** @var IURLGenerator|MockObject */
	private $urlGenerator;
	private ?\OCA\Talk\Tests\php\Recording\CustomBackendNotifier $backendNotifier = null;

	private ?Manager $manager = null;

	private ?string $recordingSecret = null;
	private ?string $baseUrl = null;

	public function setUp(): void {
		parent::setUp();

		$config = \OC::$server->getConfig();
		$this->recordingSecret = 'the-recording-secret';
		$this->baseUrl = 'https://localhost/recording';
		$config->setAppValue('spreed', 'recording_servers', json_encode([
			'secret' => $this->recordingSecret,
			'servers' => [
				[
					'server' => $this->baseUrl,
				],
			],
		]));

		$this->secureRandom = \OC::$server->getSecureRandom();
		$this->urlGenerator = $this->createMock(IURLGenerator::class);

		$groupManager = $this->createMock(IGroupManager::class);
		$userManager = $this->createMock(IUserManager::class);
		$timeFactory = $this->createMock(ITimeFactory::class);
		$dispatcher = \OC::$server->get(IEventDispatcher::class);

		$this->config = new Config($config, $this->secureRandom, $groupManager, $userManager, $this->urlGenerator, $timeFactory, $dispatcher);

		$this->recreateBackendNotifier();

		$dbConnection = \OC::$server->getDatabaseConnection();
		$this->manager = new Manager(
			$dbConnection,
			$config,
			$this->config,
			\OC::$server->get(IAppManager::class),
			\OC::$server->get(AttendeeMapper::class),
			\OC::$server->get(SessionMapper::class),
			$this->createMock(ParticipantService::class),
			$this->secureRandom,
			$this->createMock(IUserManager::class),
			$groupManager,
			$this->createMock(CommentsManager::class),
			$this->createMock(TalkSession::class),
			$dispatcher,
			$timeFactory,
			$this->createMock(IHasher::class),
			$this->createMock(IL10N::class)
		);
	}

	public function tearDown(): void {
		$config = \OC::$server->getConfig();
		$config->deleteAppValue('spreed', 'recording_servers');
		parent::tearDown();
	}

	private function recreateBackendNotifier() {
		$this->backendNotifier = new CustomBackendNotifier(
			$this->config,
			$this->createMock(LoggerInterface::class),
			$this->createMock(IClientService::class),
			$this->secureRandom,
			$this->urlGenerator,
		);
	}

	private function calculateBackendChecksum($data, $random) {
		if (empty($random) || strlen($random) < 32) {
			return false;
		}
		return hash_hmac('sha256', $random . $data, $this->recordingSecret);
	}

	private function validateBackendRequest($expectedUrl, $request) {
		$this->assertTrue(isset($request));
		$this->assertEquals($expectedUrl, $request['url']);
		$headers = $request['params']['headers'];
		$this->assertEquals('application/json', $headers['Content-Type']);
		$random = $headers['Talk-Recording-Random'];
		$checksum = $headers['Talk-Recording-Checksum'];
		$body = $request['params']['body'];
		$this->assertEquals($this->calculateBackendChecksum($body, $random), $checksum);
		return $body;
	}

	private function assertMessageWasSent(Room $room, array $message): void {
		$expectedUrl = $this->baseUrl . '/api/v1/room/' . $room->getToken();

		$requests = $this->backendNotifier->getRequests();
		$requests = array_filter($requests, function ($request) use ($expectedUrl) {
			return $request['url'] === $expectedUrl;
		});
		$bodies = array_map(function ($request) use ($expectedUrl) {
			return json_decode($this->validateBackendRequest($expectedUrl, $request), true);
		}, $requests);

		$bodies = array_filter($bodies, function (array $body) use ($message) {
			return $body['type'] === $message['type'];
		});

		$this->assertContainsEquals($message, $bodies, json_encode($bodies, JSON_PRETTY_PRINT));
	}

	public function testStart() {
		$room = $this->manager->createRoom(Room::TYPE_PUBLIC);

		$this->backendNotifier->start($room, Room::RECORDING_VIDEO, 'participant1');

		$this->assertMessageWasSent($room, [
			'type' => 'start',
			'start' => [
				'status' => Room::RECORDING_VIDEO,
				'owner' => 'participant1',
			],
		]);
	}

	public function testStop() {
		$room = $this->manager->createRoom(Room::TYPE_PUBLIC);

		$this->backendNotifier->stop($room);

		$this->assertMessageWasSent($room, [
			'type' => 'stop',
		]);
	}
}
