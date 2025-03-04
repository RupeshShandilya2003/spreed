<?php

declare(strict_types=1);

/**
 * @copyright Copyright (c) 2022 Joas Schilling <coding@schilljs.com>
 *
 * @author Joas Schilling <coding@schilljs.com>
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

namespace OCA\Talk\OCP;

use OCA\Talk\Room;
use OCP\IURLGenerator;
use OCP\Talk\IConversation;

class Conversation implements IConversation {
	protected IURLGenerator $url;
	protected Room $room;

	public function __construct(IURLGenerator $url,
								Room $room) {
		$this->url = $url;
		$this->room = $room;
	}

	public function getId(): string {
		return $this->room->getToken();
	}

	public function getAbsoluteUrl(): string {
		return $this->url->linkToRouteAbsolute('spreed.Page.showCall', ['token' => $this->room->getToken()]);
	}
}
