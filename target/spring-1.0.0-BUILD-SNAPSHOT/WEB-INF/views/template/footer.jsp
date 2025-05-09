<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
</div>
<style>
	/* 채팅 버튼 스타일 */
	.chat-button {
		position: fixed;
		bottom: 20px;
		right: 20px;
		width: 60px;
		height: 60px;
		border-radius: 50%;
		border: none;
		cursor: pointer;
		display: flex;
		align-items: center;
		justify-content: center;
		box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
		z-index: 1000;
		transition: transform 0.2s;
	}

	.chat-button:hover {
		transform: scale(1.1);
	}

	.chat-button .material-icons{
		font-size: 28px;
	}

	/* 채팅 모달 스타일 */
	.chat-modal {
		display: none;
		position: fixed;
		bottom: 90px;
		right: 20px;
		width: 100%;
		max-width: 360px; /* 모바일 화면 기준 */
		height: 70vh;
		background-color: white;
		border-radius: 12px;
		box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
		z-index: 999;
		overflow: hidden;
	}

	.chat-modal.active {
		display: flex;
		flex-direction: column;
	}

	.chat-header {
		padding: 15px;
		background-color: #2c3e50;
		color: white;
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.chat-header h3 {
		margin: 0;
		font-size: 18px;
	}

	.close-chat {
		background: none;
		border: none;
		color: white;
		cursor: pointer;
		padding: 5px;
	}

	/* 채팅 목록 시작 */

	.chat-messages {
		flex: 1;
		padding: 10px 15px;     /* 상하좌우 여백 */
		overflow-y: auto;       /* 스크롤 처리 */
		background-color: #fefefe;
		display: flex;
		flex-direction: column; /* 자식들을 세로로 쌓음 */
		gap: 6px;               /* 메시지들 사이 약간 간격 */
	}

	.chat {
		align-self: flex-start;
		max-width: 70%;
		padding: 8px 12px;
		border-radius: 18px;
		background-color: #eceff1;
		color: #333;
		font-size: 14px;
		line-height: 1;
		word-wrap: break-word;
		position: relative;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
		margin-bottom: 35px;
	}

	.chat.me {
		align-self: flex-end;
		background-color: #2c3e50;
		color: #fff;
		margin-left: auto;
	}

	.chat .chat-name {
		display: block;
		font-weight: 600;
		margin-bottom: 10px;
	}

	.chat .chat-content {
		display: block;
		margin-bottom: 4px;
	}

	.chat-content {
		flex: 1;
		display: flex;
		flex-direction: column;
		height: 92%;
		margin-top: 10px;
	}
	.chat .chat-date {
		font-size: 12px;
		color: #999;
		text-align: right;
		display: block;
	}
	.chat.me::after {
		content: "";
		position: absolute;
		right: -6px;
		top: 10px;
		border-width: 6px;
		border-style: solid;
		border-color: transparent transparent transparent #2c3e50;
	}



	/* 채팅 내용 끝 */

	.chat-input-area {
		padding: 15px;
		border-top: 1px solid #eee;
		display: flex;
		gap: 10px;
	}

	.chat-input-area input {
		flex: 1;
		padding: 10px;
		border: 1px solid #ddd;
		border-radius: 20px;
		outline: none;
	}

	.chat-input-area button {
		background-color: #2c3e50;
		color: white;
		border: none;
		border-radius: 50%;
		width: 40px;
		height: 40px;
		cursor: pointer;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.chat-container {
		display: flex;
		height: calc(100% - 60px);
		position: relative;
	}

	.invite-sidebar.active ~ .chat-nav,
	.invite-sidebar.active ~ .chat-content {
		margin-left: 280px;
		width: calc(100% - 280px);
	}

	.chat-sidebar {
		position: absolute;
		right: 0;
		width: 280px;
		height: 100%;
		border-left: 1px solid #eee;
		background: white;
		z-index: 2;
	}

	.chat-nav {
		width: 60px;
		background: #f8f9fa;
		border-left: 1px solid #eee;
		display: flex;
		flex-direction: column;
		align-items: center;
		padding-top: 20px;
	}

	.nav-icon {
		width: 40px;
		height: 40px;
		display: flex;
		align-items: center;
		justify-content: center;
		border-radius: 50%;
		margin-bottom: 10px;
		cursor: pointer;
	}

	.nav-icon.active {
		background: #2c3e50;
		color: white;
	}


	.nav-icon .material-icons {
		margin-right: 5px;
		font-size: 20px;
	}

	.chat-room {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		display: flex;
		flex-direction: column;
	}

	.chat-room .chat-header {
		padding: 15px;
		display: flex;
		align-items: center;
	}

	.chat-room .back-button {
		background: none;
		border: none;
		color: white;
		cursor: pointer;
		margin-right: 10px;
	}

	.chat-content {
		flex: 1;
		display: flex;
		flex-direction: column;
		overflow: hidden;
	}

	.chat-content.full-width {
		padding-right: 0;
	}

	.chat-sidebar {
		width: 280px;
		border-right: 1px solid #eee;
		display: flex;
		flex-direction: column;
	}

	.search-box {
		padding: 15px;
		border-bottom: 1px solid #eee;
	}

	.search-box input {
		width: 100%;
		padding: 8px;
		border: 1px solid #ddd;
		border-radius: 20px;
		outline: none;
	}

	.employee-list {
		flex: 1;
		overflow-y: auto;
	}

	.employee-item {
		padding: 15px;
		display: flex;
		align-items: center;
		cursor: pointer;
		transition: background-color 0.2s;
	}

	.employee-item:hover {
		background-color: var(--md-sys-color-surface-container);
	}

	.invite-target {
		padding: 15px;
		display: flex;
		align-items: center;
		cursor: pointer;
		transition: background-color 0.2s;
	}

	.invite-target:hover {
		background-color: var(--md-sys-color-surface-container);
	}

	.employee-avatar {
		width: 40px;
		height: 40px;
		border-radius: 50%;
		margin-right: 12px;
		background-color: #ddd;
		background-size: cover;
	}

	.employee-info {
		flex: 1;
	}

	.employee-name {
		font-weight: bold;
		margin-bottom: 4px;
	}

	.employee-position {
		font-size: 12px;
		color: #666;
	}

	/* 모바일 반응형 */
	@media (max-width: 768px) {
		.chat-modal {
			/*width: calc(100% - 40px);*/
			/*right: 20px;*/
			/*bottom: 90px;*/
			max-width: none !important;
			right:    0 !important;
			bottom:   0 !important;
			/* 화면 꽉 채우기 */
			top:    0 !important;
			left:   0 !important;
			width:  100vw  !important;
			height: 100vh  !important;
			/* 모서리 둥글기 없애기 */
			border-radius: 0 !important;
			/* 네비/푸터 위로 올라오기 */
			z-index: 9999 !important;
		}
	}
	.room-list {
		width: 100%;
		height: 100%;
		overflow-y: auto;
	}

	.invite-sidebar {
		width: 190px;
		height: 100%;
		background: white;
		border-right: 1px solid #eee;
		display: flex;
		flex-direction: column;
		position: absolute;
		left: 0;
		z-index: 3;
	}
	#chat-user-title {
		cursor: pointer;
	}
	.roomEmployeeList {
		display: none;
		position: absolute;
		top: 9.9%;
		width: 100%;
		max-width: 360px;
		min-height: 15vh;
		height: auto;
		background-color: #fff;
		border-radius: 12px;
		box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
		z-index: 999;
		overflow: hidden;
	}
	.roomEmployeeList-content {
		flex: 1;
		padding: 20px;
		overflow-y: auto;
		background-color: #fefefe;
	}
	.roomEmployeeList-header {
		background-color: #2c3e50;
		color: #fff;
		padding: 12px 15px;
		font-size: 16px;
		font-weight: bold;
		display: flex;
		justify-content: center;
		align-items: center;
		border-radius: 8px;
		margin-bottom: 15px;
	}
	.roomEmployeeList.active {
		display: flex;
		flex-direction: column;
	}
	#participantList {
		background-color: #2c3e50;
		padding: 10px;
		border-radius: 8px;
		color: #fff;
		max-height: calc(55vh - 100px);
		overflow-y: auto;
	}
	.participant-item {
		margin-bottom: 15px;
		font-size: 15px;
	}
	.notification {
		text-align: center;
	}
	.alarm-badge {
		display: inline-block;
		min-width: 20px;
		padding: 2px 6px;
		border-radius: 10px;
		background-color: red;
		color: #fff;
		text-align: center;
		font-size: 12px;
		margin-left: 6px;
		vertical-align: middle;
	}

	.chat-alarm-badge {
		position: absolute;
		top: -5px;
		right: -5px;
		min-width: 20px;
		height: 20px;
		padding: 0 6px;
		background-color: red;
		color: #fff;
		font-size: 12px;
		border-radius: 50%;
		display: none;
		text-align: center;
		line-height: 20px;
	}

</style>
<button id="chatButton" class="chat-button surface-bright">
	<span class="material-icons">chat</span>
	<span class="chat-alarm-badge" style="display: none;"></span>
</button>

<div id="chatModal" class="chat-modal surface-bright">
	<div class="chat-header">
		<h3>채팅</h3>
		<button class="invite-chat" style="display: none">
			<span class="material-icons">add</span>
		</button>
		<button class="close-chat">
			<span class="material-icons">close</span>
		</button>
	</div>
	<div class="chat-container">

		<!-- 채팅방 초대 -->
		<div class="invite-sidebar" style="display: none;">
			<div class="search-box">
				<input type="text" placeholder="사원 검색...">
			</div>
			<div class="employee-list">
				<!-- 사원 목록이 여기에 동적으로 생성됨 -->
			</div>
		</div>

		<div class="roomEmployeeList">
			<div class="roomEmployeeList-content">
				<div class="roomEmployeeList-header">현재 채팅방 참여자 목록</div>
				<div id="participantList"></div>
			</div>
		</div>

		<!-- 오른쪽 네비게이션 영역 -->
		<div class="chat-nav">
			<div class="nav-icon active" data-view="employees">
				<span class="material-icons">people</span>
			</div>
			<div class="nav-icon" data-view="rooms">
				<span class="material-icons">forum</span>
			</div>
		</div>
		<!-- 메인 컨텐츠 영역 -->
		<div class="chat-content">
			<div class="search-box">
				<input type="text" placeholder="사원 검색...">
			</div>
			<div class="employee-list">
				<!-- 사원 목록이 여기에 동적으로 생성됨 -->
			</div>
		</div>

		<div class="room-list" style="display: none;">
			<!-- 채팅방 목록이 여기에 생성됨 -->
		</div>

		<!-- 채팅방 영역  -->
		<div class="chat-room" style="display: none;">
			<div class="chat-header">
				<button class="back-button">
					<span class="material-icons">arrow_back</span>
				</button>
				<h3 id="chat-user-title"></h3>
			</div>

			<!-- 메시지 영역 -->
			<div class="chat-messages"></div>

			<div class="chat-input-area">
				<input type="text" placeholder="메시지를 입력하세요..." id="chat-input">
				<button type="button">
					<span class="material-icons">send</span>
				</button>
			</div>
		</div>
	</div>
</div>
<input type="hidden" id="selected-employee-id" value="">
<input type="hidden" id="sender-employee-id" value=${employee.id}>
<input type="hidden" id="sender-name" value="${employee.name}">
<script>
	$(document).ready(function() {
		let ws = new WebSocket("wss://end2end.site/chat");
		let employees = [];
		let chatRooms = [];
		let currentRoomId = 0;
		let roomEmployeeList = [];
		let invitedIds = [];
		var globalRoomAlarms = {};
		refreshChatRoomList();

		ws.onmessage = function (e) {
			let msg = JSON.parse(e.data);
			if (msg.type === "invite") {
				return;
			}
			if (msg.type === "NEW_CHAT_ROOM") {
				currentRoomId = msg.roomId;
				addNewChatRoomItem(msg);
				return;
			} else if(msg.type === "history") {
				roomEmployeeList = msg.employees;
				if (msg.roomId) {
					currentRoomId = msg.roomId;
				}
				$(".chat-messages").empty();
				msg.messages.forEach(function(m) {
					let dateObj = new Date(m.regDate);
					let now = new Date();
					let formattedDate = "";
					if (
							now.getFullYear() === dateObj.getFullYear() &&
							now.getMonth() === dateObj.getMonth() &&
							now.getDate() === dateObj.getDate()
					) {
						formattedDate = dateObj.toLocaleTimeString('ko-KR', {
							hour: 'numeric',
							minute: 'numeric',
							hour12: true
						});
					} else {
						let month = (dateObj.getMonth() + 1).toString().padStart(2, '0');
						let day = dateObj.getDate().toString().padStart(2, '0');
						let dateStr = month + "-" + day;
						let timeStr = dateObj.toLocaleTimeString('ko-KR', {
							hour: 'numeric',
							minute: 'numeric',
							hour12: true
						});
						formattedDate = dateStr + " " + timeStr;
					}
					let chat = $("<div>").addClass(m.employeeId === $("#sender-employee-id").val() ? "chat me" : "chat");
					let chatName = $("<span>").addClass("chat-name").text(m.name);
					let chatContent = $("<span>").addClass("chat-content").text(m.content);
					let chatDate = $("<span>").addClass("chat-date").text(formattedDate);
					chat.append(chatName, chatContent, chatDate);
					$(".chat-messages").append(chat);
					$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
				});
				return;
			} else if(msg.type === "NEW_INVITE") {
				let chat = $("<div>").html(msg.message).addClass("notification");
				$(".chat-messages").append(chat);
				roomEmployeeList = msg.employees;
				return;
			} else if(msg.type === "alarmCount") {
				globalRoomAlarms = msg.roomAlarms;
				updateAlarmBadges(globalRoomAlarms);
				if (!$("#chatModal").hasClass("active")) {
					if (msg.count > 0) {
						$(".chat-button").find(".chat-alarm-badge").text(msg.count).show();
					} else {
						$(".chat-button").find(".chat-alarm-badge").hide();
					}
				} else {
					$(".chat-button").find(".chat-alarm-badge").hide();
				}
				refreshChatRoomList();
				return;
			}
			if (currentRoomId != msg.messagerRoomId) {
				return;
			}
			let chat = $("<div>")
					.addClass(msg.employeeId === $("#sender-employee-id").val() ? "chat me" : "chat");
			let chatName = $("<span>").addClass("chat-name").text(msg.name);
			let chatContent = $("<span>").addClass("chat-content").text(msg.content);
			let chatDate = $("<span>").addClass("chat-date").text(
					new Date().toLocaleTimeString('ko-KR', { hour: 'numeric', minute: 'numeric', hour12: true })
			);
			chat.append(chatName, chatContent, chatDate);
			$(".chat-messages").append(chat);
			$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
			updateLastMessageInRoom(msg);
			refreshChatRoomList();
		}

		//사원 목록 출력
		$.ajax({
			url:"/messenger/employeeListAll"
		}).done(function (resp) {
			let list = resp.employeeListAll;
			for (let i = 0; i < list.length; i++) {
				let position = list[i].teamName + " " + list[i].jobName;
				employees.push ({
					id: list[i].id,
					name: list[i].name,
					position: position,
					profileImg: list[i].profileImg
				});
			}
			renderEmployeeList();
		});

		refreshChatRoomList();
		function refreshChatRoomList() {
			$.ajax({
				url:"/messenger/chatListAll"
			}).done(function (resp) {
				chatRooms = resp.chatListAll;
				renderRoomList(chatRooms);
				setTimeout(renderRoomList, 30000);
			});
		}

		//대화방 목록
		$('#chat-user-title').on('click', function() {
			const myId = $('#sender-employee-id').val();
			$('#participantList').empty();
			roomEmployeeList.forEach(employeeId => {
				if(String(employeeId) !== String(myId)) {
					const employee = employees.find(emp => String(emp.id) === String(employeeId));
					if (employee) {
						$('#participantList').append(
								$('<div>').addClass('participant-item').text(employee.name)
						);
					} else {
						$('#participantList').append(
								$('<div>').addClass('participant-item').text(employeeId)
						);
					}
				}
			});
			$('.roomEmployeeList').toggleClass('active');
		});

		const chatButton = $('#chatButton');
		const chatModal = $('#chatModal');
		const closeChat = $('.close-chat');
		const employeeList = $('.employee-list');
		const chatContent = $('.chat-content');
		const chatInput = $('#chat-input');
		const sendButton = $('.chat-input-area button');

		let isModalOpen = false; // 모달 상태를 추적하는 변수

		chatButton.on('click', function(e) {
			e.stopPropagation(); // 이벤트 버블링 방지
			isModalOpen = !isModalOpen;
			if(isModalOpen) {
				chatModal.addClass('active');
			} else {
				chatModal.removeClass('active');
			}
		});

		$('.mobile-chat-btn').on('click', function(e) {
			e.preventDefault();
			e.stopPropagation(); // 이벤트 버블링 방지
			isModalOpen = !isModalOpen;
			if(isModalOpen) {
				chatModal.addClass('active');
			} else {
				chatModal.removeClass('active');
			}
		});

		closeChat.on('click', function(e) {
			e.stopPropagation(); // 이벤트 버블링 방지
			isModalOpen = false;
			chatModal.removeClass('active');
		});

		function addNewChatRoomItem(roomInfo) {
			let newRoomElement = makeChatRoomListItem(roomInfo);
			$(".room-list").prepend(newRoomElement);
		}

		<%--const $item = $(`.room-list .employee-item[data-room-id='${roomId}']`);--%>
		function updateLastMessageInRoom(msg) {
			const roomId = msg.roomId || msg.messagerRoomId;
			let idx = chatRooms.findIndex(r => String(r.roomId) === String(roomId));
			if (idx !== -1) {
				chatRooms[idx].lastMessage = msg.content;
				let $item = $(".room-list").find(`.employee-item[data-room-id = '${roomId}']`);
				if ($item.length) {
					$item.find(".employee-position")
							.text(msg.content);
				}
			}
			// let roomIndex = chatRooms.findIndex(room =>
			// 		String(room.roomId || room.messagerRoomId) === String(msg.roomId)
			// );
			//
			// if (roomIndex !== -1) {
			// 	chatRooms[roomIndex].lastMessage = msg.content || "No messages yet";
			// 	let updatedRoom = chatRooms.splice(roomIndex, 1)[0];
			// 	chatRooms.unshift(updatedRoom);
			// 	let $roomElement = $(".room-list").find(".employee-item[data-room-id='" + msg.roomId + "']");
			// 	if ($roomElement.length) {
			// 		$roomElement.find(".employee-position").text(updatedRoom.lastMessage);
			// 		$roomElement.detach().prependTo($(".room-list"));
			// 	} else {
			// 		renderRoomList(chatRooms);
			// 	}
			// } else {
			// 	refreshChatRoomList();
			// }
		}


		function sendMessage() {
			const message = chatInput.val().trim();
			if (message) {
				chatInput.val('');
			} else if(message == '') {
				return;
			} else if(currentRoomId === 0 ) {
				alert("유효한 채팅방이 아닙니다. 상대방을 먼저 선택해주세요.");
				return;
			}
			const payload = {
				type: "message",
				employeeId: $('#sender-employee-id').val(),
				message: message,
				roomId: currentRoomId
			};
			ws.send(JSON.stringify(payload));
		}

		sendButton.on('click', sendMessage);

		chatInput.on('keydown', function(e) {
			if (e.key === 'Enter') {
				sendMessage();
			}
		});

		const makeChatEmployeeList = (employee, index) => {
			const div = $('<div>').addClass('employee-item').attr('data-id', employee.id).attr('data-name', employee.name);
			const avatarUrl = employee.profileImg ? employee.profileImg : "https://picsum.photos/id/23/200/200";
			const avatar = $('<div>')
					.addClass('employee-avatar')
					.css('background-image', "url('" + avatarUrl + "')");
			const info = $('<div>').addClass('employee-info');
			const name = $('<div>').addClass('employee-name').html(employee.name);
			const position = $('<div>').addClass('employee-position').text(employee.position);
			info.append(name, position);
			div.append(avatar, info);
			return div;
		}

		// 사원 목록 렌더링
		function renderEmployeeList(data) {
			const listData = data || employees;
			listData.forEach((employee, index) => {
				const employeeItem = makeChatEmployeeList(employee, index);
				$('.invite-sidebar .employee-list').append(employeeItem.clone(true).addClass('invite-user'));
				$('.chat-content .employee-list').append(employeeItem.clone());
			});
		}

		// 검색 기능
		const searchInput = $('.search-box input');
		searchInput.on('input', function(e) {
			const searchTerm = e.target.value.toLowerCase();
			const filteredEmployees = employees.filter(emp =>
					emp.name.toLowerCase().includes(searchTerm) ||
					emp.position.toLowerCase().includes(searchTerm)
			);
			if ($('.invite-sidebar').is(':visible')) {
				renderInviteList(filteredEmployees);
			} else {
				renderEmployeeList(filteredEmployees);
			}
		});

		function renderInviteList(data) {
			const listData = data || employees;
			const filteredData = listData.filter(employee => {
				return invitedIds.indexOf(employee.id) === -1
						&& roomEmployeeList.indexOf(employee.id) === -1;
			});
			$('.invite-sidebar .employee-list, .chat-content .employee-list').empty();
			filteredData.forEach((employee, index) => {
				const employeeItem = makeChatEmployeeList(employee, index)
						.removeClass("employee-item")
						.addClass("invite-target");
				$('.invite-sidebar .employee-list').append(employeeItem.clone(true));
				$('.chat-content .employee-list').append(employeeItem.clone(true));
			});
		}

		//초대버튼 UI
		$('.invite-chat').on("click", function() {
			if ($('.invite-sidebar').is(':visible')) {
				$('.invite-sidebar').hide();
				$('.chat-nav, .chat-content').css('margin-left', '0');
			} else {
				$('.invite-sidebar, .employee-list, .search-box').show();
				$('.chat-nav, .chat-content').css('margin-left', '280px');
				renderInviteList();
			}
		});
		// 실제 초대 로직
		$(document).on('click', '.invite-sidebar .invite-target', function() {
			const inviteeId = $(this).data('id');
			const inviteeName = $(this).data('name');
			if (!currentRoomId || currentRoomId === 0) {
				alert("유효한 대화방 정보가 없습니다. 초대 전, 채팅방을 먼저 확인해주세요.");
				return;
			}
			let currentTitle = $('#chat-user-title').text();
			let totalCount = 0;
			let names = [];
			if (currentTitle.includes(' 외 ') && currentTitle.includes(',')) {
				const parts = currentTitle.split(' 외 ');
				names = parts[0].split(', ').map(name => name.trim());
				const countText = parts[1].replace('명', '').trim();
				const additionalCount = parseInt(countText) || 0;
				totalCount = names.length + additionalCount;
			}
			else if (currentTitle.includes(',')) {
				names = currentTitle.split(', ').map(name => name.trim());
				totalCount = names.length;
			}
			else if (currentTitle.trim() !== '') {
				names = [currentTitle.trim()];
				totalCount = 1;
			}
			if (!names.includes(inviteeName)) {
				totalCount += 1;
				if (names.length < 2) {
					names.push(inviteeName);
				}
				if (totalCount <= 3) {
					if (names.length < totalCount) {
						names = [...names, /* 조회한 추가 이름 */];
					}
					currentTitle = names.slice(0, totalCount).join(', ');
				} else {
					const displayNames = names.length >= 2 ? names.slice(0, 2) : [...names, /* 조회한 추가 이름 */].slice(0, 2);
					const remainingCount = totalCount - 2;
					currentTitle = displayNames.join(', ') + ' 외 ' + remainingCount + '명';
				}

				$('#chat-user-title').text(currentTitle);
			}
			let payload = {
				type: "invite",
				inviteeId: inviteeId,
				inviteeName: inviteeName,
				roomId: currentRoomId
			};
			ws.send(JSON.stringify(payload));
			$('.invite-sidebar').hide();
			$('.chat-nav, .chat-content').css('margin-left', '0');
		});

		$(document).on('click', '.employee-item', function() {
			const employeeId = $(this).data('id');
			const employeeName = $(this).find('.employee-name').text();
			const roomId = $(this).data('room-id') || 0;
			$('#selected-employee-id').val(employeeId);
			showChatRoom(employeeId, employeeName, roomId);
		});

		// 사원 목록 렌더링 함수 수정
		function renderEmployeeList(data) {
			const listData = data || employees;
			$('.invite-sidebar .employee-list, .chat-content .employee-list').empty();
			listData.forEach((employee, index) => {
				const employeeItem = makeChatEmployeeList(employee, index);
				$('.invite-sidebar .employee-list').append(employeeItem.clone(true));
				$('.chat-content .employee-list').append(employeeItem.clone(true));
			});
		}

		//채팅방 생성
		function showChatRoom(employeeId, employeeName, roomId) {
			$(".chat-messages").empty();
			if (window.innerWidth <= 768) {
				$('.chat-sidebar').css('display', 'none');
			}
			chatContent.css('display', 'flex');
			$('.employee-item').each(function() {
				$(this).removeClass('active');
				if ($(this).data('id') === employeeId) {
					$(this).addClass('active');
				}
			});
			$('#chat-user-title').text(employeeName);
			$('#selected-employee-id').val(employeeId);
			$('.chat-content, .chat-nav, .room-list').hide();
			$('.chat-room').show();
			$('.invite-chat').show();

			$('.invite-sidebar').hide();
			$('.chat-nav, .chat-content').css('margin-left', '0');
			currentRoomId = roomId;
			if (roomId === 0) {
				const payload = {
					type: "newRoom",
					employeeId: employeeId
				};
				ws.send(JSON.stringify(payload));
			} else {
				const payload = {
					type: "roomEnter",
					roomId: roomId,
					employeeId: $('#sender-employee-id').val()
				};
				ws.send(JSON.stringify(payload));
				currentRoomId = roomId;
			}
		}
		function makeChatRoomListItem(room) {
			const roomId = room.roomId || room.messageRoomId;
			let displayName = room.roomName;
			if (displayName && displayName.indexOf('|') !== -1) {
				let parts = displayName.split('|');
				let myId = $('#sender-employee-id').val();
				let otherIds = parts.filter(id => String(id) !== String(myId));
				if (otherIds.length === 1) {
					let matchedEmployee = employees.find(emp => String(emp.id) === String(otherIds[0]));
					if (matchedEmployee) {
						displayName = matchedEmployee.name;
					}
				} else if (otherIds.length > 1) {
					let names = [];
					otherIds.forEach(otherId => {
						let emp = employees.find(emp => String(emp.id) === String(otherId));
						if (emp) {
							names.push(emp.name);
						}
					});
					if (names.length > 3) {
						let firstTwo = names.slice(0, 2);
						let remainingCount = names.length - 2;
						displayName = firstTwo.join(', ') + ' 외 ' + remainingCount + '명';
					} else {
						displayName = names.join(', ');
					}
				}
			}
			const div = $('<div>').addClass('employee-item').attr('data-room-id', roomId);
			const avatarUrl = room.profileImg ? room.profileImg : "https://picsum.photos/id/23/200/200";
			const avatar = $('<div>')
					.addClass('employee-avatar')
					.css('background-image', "url('" + avatarUrl + "')");
			const info = $('<div>').addClass('employee-info');
			const name = $('<div>').addClass('employee-name').text(displayName);
			const lastMsg = $('<div>').addClass('employee-position').text(room.lastMessage || "No messages yet");

			info.append(name, lastMsg);
			div.append(avatar, info);
			return div;
		}


		function renderRoomList() {
			const roomListContainer = $('.room-list');
			roomListContainer.empty();
			if (chatRooms && chatRooms.length > 0) {
				chatRooms.forEach(room => {
					roomListContainer.append(makeChatRoomListItem(room));
				});
				updateAlarmBadges(globalRoomAlarms);
			} else {
				roomListContainer.append('<div class="no-rooms">No chat rooms available</div>');
			}
		}

		// 뒤로가기 버튼 이벤트
		$('.back-button').on('click', function() {
			const view = $('.nav-icon.active').data('view');
			$('.invite-chat').hide();
			$('.roomEmployeeList').removeClass('active');
			if(view === 'employees') {
				$('.chat-room').hide();
				$('.chat-content, .chat-nav').show();
				renderEmployeeList();
			} else if (view === 'rooms') {
				$('.chat-room').hide();
				$('.chat-content, .chat-nav, .room-list').show();
				renderRoomList();
			}

		});

		function updateAlarmBadges(roomAlarms) {
			$.each(roomAlarms, function(roomId, alarmCount) {
				var $targetItem = $(".room-list").find(".employee-item[data-room-id='" + roomId + "']");
				if ($targetItem.length > 0) {
					var $name = $targetItem.find(".employee-name");
					var $badge = $name.find(".alarm-badge");
					if (alarmCount > 0) {
						if ($badge.length) {
							$badge.text(alarmCount);
						} else {
							$badge = $("<span></span>")
									.addClass("alarm-badge")
									.text(alarmCount);
							$name.append($badge);
						}
					} else {
						if ($badge.length) {
							$badge.remove();
						}
					}
				}
			});
		}


		// 네비게이션 아이콘 클릭 이벤트
		$('.nav-icon').on('click', function() {
			$('.nav-icon').removeClass('active');
			$(this).addClass('active');
			const view = $(this).data('view');

			// 여기에 각 뷰에 따른 컨텐츠 전환 로직 추가
			if(view === 'employees') {
				$('.employee-list').show();
				$('.search-box').show();
				$('.chat-content').show();
				$('.room-list').hide();
				renderEmployeeList();
			} else if (view === 'rooms') {
				$('.employee-list').hide();
				$('.search-box').hide();
				$('.chat-content').hide();
				$('.room-list').show();
				renderRoomList();
			}
		});
	});
</script>
</div>
</div>
</div>
</body>
</html>