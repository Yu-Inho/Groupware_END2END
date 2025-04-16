<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/template/header.jsp" />
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="/css/template/exam.css" />
<link rel="stylesheet" href="/css/main/index.css" />
<style>
    .birth-item {
        height: 60px; /* 원하는 높이로 조절 */
        min-height: 60px; /* 최소 높이 지정 */
        max-height: 60px; /* 최대 높이 지정 */
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    /* 내부 요소들의 정렬을 위해 */
    .birth-profile {
        display: flex;
        align-items: center;
        height: 100%;
    }

    .birth-info {
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    /* 엑스트라 라지 사이즈 (1200px) */
    @media screen and (max-width: 1200px) {
        .rightContents {
            display: none;
        }

        .boxContents {
            display: grid;
            grid-template-columns: 1fr 2fr; /* 1:2 비율로 설정 */
            gap: 20px;
        }

        .leftContents {
            width: 100%;
        }

        .centerContents {
            width: 100%;
        }
    }

    @media screen and (max-width: 992px) {
        .boxContents {
            display: flex;
            flex-direction: column;
            gap: 20px;
            padding: 20px;
            padding-bottom: 80px; /* 하단 패딩 추가 */
        }

        .leftContents,
        .centerContents {
            width: 100%;
        }

        /* leftContents와 centerContents의 그리드 해제 */
        .leftContents,
        .centerContents {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* 각 박스들의 높이 조정 */
        .logbox,
        .commuteBox,
        .calendarBox,
        .boardBox,
        .approvalBox {
            grid-row: unset; /* 그리드 속성 해제 */
            min-height: 300px; /* 최소 높이 설정 */
        }

        .information {
            flex-direction: row;
            justify-content: center;
        }
    }

    /* 이벤트 높이 조절 */
    .fc-event {
        height: 5px !important;  /* 원하는 높이로 조절 */
        line-height: 5px !important;
        padding: 0 !important;
        margin: 1px 0 !important;
    }

    /* 이벤트 컨테이너 높이 조절 */
    .fc-daygrid-event-harness {
        height: 5px !important;
    }

    /* 여러 이벤트가 있을 때의 간격 조절 */
    .fc .fc-daygrid-day-events {
        margin-top: 0 !important;
        margin-bottom: 0 !important;
    }

    /* 이벤트 내부 여백 제거 */
    .fc-daygrid-event {
        padding: 0 !important;
    }
</style>
<style>
    .detail-modal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    /* box, box-content 스타일을 활용하면서 모달 특성에 맞게 일부 수정 */
    .detail-modal .modal-container {
        width: 500px;  /* 모달 너비 조정 */
        margin: 0;     /* box 클래스의 기본 마진 제거 */
    }

    .detail-modal .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .detail-modal .modal-header h2 {
        font-size: 1.5rem;
        font-weight: bold;
        margin: 0;
    }

    .detail-modal .modal-close {
        border: none;
        cursor: pointer;
        padding: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .detail-modal .modal-body {
        max-height: 70vh;
        overflow-y: auto;
    }

    .detail-modal .form-group {
        margin-bottom: 15px;
    }

    .detail-modal .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: var(--md-sys-color-surface);
    }

    .detail-modal .form-group input,
    .detail-modal .form-group textarea {
        width: 100%;
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
    }

    .detail-modal .form-group input,
    .detail-modal .form-group textarea {
        width: 100%;
        padding: 8px 12px;
        border: 1px solid var(--md-sys-color-outline-variant);
        border-radius: 4px;
        background-color: var(--md-sys-color-surface-bright);
        color: var(--md-sys-color-surface);
    }

    .modal-header .material-icons {
        cursor: pointer;
    }
</style>
<script>
    function calculateAvailableDimensions() {
        const $container = $('.calendarBox');
        const totalHeight = $container.height();
        const totalWidth = $container.width();
        const titleHeight = $('.boxTitle').outerHeight(true);
        const padding = 40; // 상하/좌우 padding 20px * 2

        console.log(totalHeight - titleHeight - padding);
        console.log(totalWidth - padding);
        return {
            height: totalHeight - titleHeight - padding,
            width: totalWidth - padding
        };
    }

    document.addEventListener('DOMContentLoaded', function() {
        const calendarEl = document.getElementById('calendar');
        const calendar = new FullCalendar.Calendar(calendarEl, {
            locale: 'ko',
            headerToolbar: {
                left: 'title',
                right: 'prev,next',
            },
            // 이벤트 텍스트 숨기기
            eventContent: function(info) {
                return '';
            },
            initialView: 'dayGridMonth',
            initialDate: new Date(),
            width: '100%',
            height: 'auto',
            events: function(info, successCallback) {
                const startDate = info.start;
                const endDate = info.end;

                loadEvents(startDate, endDate, successCallback);
            },
            eventClick: function(info) {
                console.log(info);
                if (info.event.extendedProps.type === 'schedule') {
                    console.log(info.event.extendedProps.id);
                    openDetailModal(info.event.extendedProps.id);
                }
            },
            eventDisplay: 'block',
            // 헤더 스타일 설정
            viewDidMount: function () {
                adjustCalendarSize();
            }
        });

        function adjustCalendarSize() {
            const dimensions = calculateAvailableDimensions();

            // 캘린더 컨테이너에 크기 적용
            $('#calendar').css({
                'width': dimensions.width + 'px',
                'max-width': '100%'
            });

            // FullCalendar 내부 요소 조정
            $('.fc').css({
                'width': '100%',
                'font-size': dimensions.width < 500 ? '0.8em' : '1em' // 작은 화면에서 폰트 크기 조정
            });
        }

        function parseDate(dates) {
            const parsedMonth = (dates.getMonth() + 1) < 10 ? '0' + (dates.getMonth() + 1) : (dates.getMonth() + 1);
            return dates.getFullYear() + '-' + parsedMonth + '-' + dates.getDate();
        }

        function loadEvents(startDate, endDate, successCallback) {
            startDate = parseDate(startDate);
            endDate = parseDate(endDate);

            console.log(startDate, endDate);

            $.ajax({
                url: '/schedule/list?startDate=' + startDate + '&endDate=' + endDate,
                type: 'GET',
                success: function (data) {
                    console.log(data);
                    const events = data.map(function(event) {
                        console.log(event);
                        if (event.eventName === 'period') {
                            return {
                                id: event.id,
                                start: new Date(event.startDate),
                                end: new Date(event.endDate),
                                display: 'block',
                                color: event.backgroundColor,
                                extendedProps: {
                                    id: event.id,
                                    type: 'schedule'
                                }
                            }
                        }
                        return {
                            title: event.title,
                            start: new Date(event.startDate),
                            allDay: event.allDay,
                            display: 'block',
                            color: event.backgroundColor,
                        }
                    })
                    console.log(events);
                    successCallback(events);
                }, errors: function(xhr, status, error) {
                    console.log(xhr.status);
                    console.log(xhr.responseText);
                    console.log(error);
                }
            })
        }

        function openDetailModal(id) {
            $.ajax({
                url: '/schedule/detail/' + id,
                type: 'GET',
                success: function (data) {
                    const startDateTime = new Date(data.startDate);
                    const endDateTime = new Date(data.endDate);

                    const startDate = formatDate(startDateTime);
                    const startTime = ' ' + formatTimeToHHMMSS(startDateTime);

                    const endDate = formatDate(endDateTime);
                    const endTime = ' ' + formatTimeToHHMMSS(endDateTime);

                    $('#detail-title').text(data.title);
                    $('#detail-start').text(startDate + startTime);
                    $('#detail-end').text(endDate + endTime);
                    $('#detail-content').text(data.content);

                    $('#eventDetailModal').show();
                }
            })
        }

        calendar.render();

        function formatDate(date) {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return year + '-' + month + '-' + day;
        }

        function formatTimeToHHMMSS(date) {
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');
            const seconds = String(date.getSeconds()).padStart(2, '0');
            return hours + ':' + minutes + ':' + seconds;
        }
    });

    // 창 크기 변경 시 자동 조절
    let resizeTimer;
    $(window).resize(function() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function() {
            const dimensions = calculateAvailableDimensions();
            // calendar.setOption('height', dimensions.height);
            // adjustCalendarSize();
        }, 100);
    });
</script>
    <div class="leftContents">
        <div class="logbox surface-bright">
            <div class="imgBox" style="background-image: url(${employee.profileImg})"></div>
            <div class="information">
                <div class="info-item name">
                    ${employee.name} ${employee.jobName}
                </div>
                <div class="info-item department">
                    ${employee.departmentName}
                </div>
            </div>
            <div class="info-summary">
                <div class="summary-item">
                    <div class="summary-left">
                        <span class="material-icons">mail</span>
                        <span class="summary-text">새 메일</span>
                    </div>
                    <span class="summary-count">5</span>
                </div>
                <div class="summary-item">
                    <div class="summary-left">
                        <span class="material-icons">event</span>
                        <span class="summary-text">오늘 일정</span>
                    </div>
                    <span class="summary-count">3</span>
                </div>
            </div>
        </div>
        <div class="commuteBox surface-bright">
            <div class="boxTitle">출퇴근 관리</div>
            <div class="timeDisplay">
                <div class="currentDate"></div>
                <div class="currentTime"></div>
            </div>
            <div class="commuteButtons">
                <button class="startWork primary ${isWorkOn ? 'disabled' : ''}"
                ${isWorkOn ? 'disabled' : ''}>출근하기</button>
                <button class="endWork primary ${isWorkOff ? 'disabled' : ''}"
                ${isWorkOff ? 'disabled' : ''}>퇴근하기</button>
            </div>
        </div>
        <div class="calendarBox surface-bright">
            <div class="boxTitle">일정</div>
            <div id="calendar"></div>
        </div>
    </div>

    <div class="centerContents">

        <div class="boardBox surface-bright">
            <div class="boxTitle">게시글 목록</div>
            <div class="board-container">
                <!-- 게시판 타입 버튼 -->
                <div class="board-type-buttons">
                    <button class="board-type-btn active">공지 게시판</button>
                    <button class="board-type-btn">전사 게시판</button>
                    <button class="board-type-btn">그룹 게시판</button>
                </div>

                <div class="category-list-container">
                    <div class="category-list">
                        <button class="category-btn active">전체</button>
                        <button class="category-btn">인사</button>
                        <button class="category-btn">회계</button>
                        <button class="category-btn">영업</button>
                        <button class="category-btn">마케팅</button>
                        <button class="category-btn">개발</button>
                        <button class="category-btn">기타</button>
                    </div>

                    <a href="/board/list" class="more-btn">
                        더보기 <span class="material-icons" style="font-size: 16px; vertical-align: middle;">chevron_right</span>
                    </a>
                </div>

                <!-- 게시글 테이블 -->
                <div class="board-table-container">
                    <table class="board-table">
                        <thead>
                        <tr>
                            <th width="8%">번호</th>
                            <th width="52%">제목</th>
                            <th width="20%">글쓴이</th>
                            <th width="20%">등록일자</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach begin="1" end="8" var="i">
                            <tr>
                                <td>${11 - i}</td> <!-- 10부터 1까지 역순으로 표시 -->
                                <td class="title">샘플 게시글 제목입니다 ${11 - i}</td>
                                <td class="writer-info">
                                    <div class="profile-img" style="background-image: url('https://picsum.photos/seed/${i}/200')"></div>
                                    <span>작성자${i}</span>
                                </td>
                                <td>2024-03-19</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="approvalBox surface-bright">
            <div class="boxTitle">나의 결재 대기 문서함</div>
            <div class="board-container">
                <div class="board-table-container">
                    <table class="board-table">
                        <thead>
                        <tr>
                            <th width="10%">기안 번호</th>
                            <th width="50%">제목</th>
                            <th width="20%">기안자</th>
                            <th width="20%">등록 일자</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach begin="1" end="7" var="i">
                            <tr>
                                <td>문서-${5 - i}</td>
                                <td class="title">결재 문서 제목입니다 ${5 - i}</td>
                                <td class="writer-info">
                                    <div class="profile-img" style="background-image: url('https://picsum.photos/seed/${i}/200')"></div>
                                    <span>기안자${i}</span>
                                </td>
                                <td>2024-03-19</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="rightContents">
        <div class="btnBox">
            <button type="button" class="surface-bright" onclick="location.href='/board/write'">
                <span class="material-icons">article</span>
                <span class="btn-text">게시글 작성</span>
            </button>
            <button type="button" class="surface-bright" onclick="location.href='/mail/write'">
                <span class="material-icons">mail</span>
                <span class="btn-text">메일 작성</span>
            </button>
            <button type="button" class="surface-bright" onClick="location.href='/approval/list'">
                <span class="material-icons">edit_note</span>
                <span class="btn-text">결재 작성</span>
            </button>
            <button type="button" class="surface-bright" onclick="location.href='/project/main'">
                <span class="material-icons">work</span>
                <span class="btn-text">보고서 작성</span>
            </button>
        </div>

        <div class="birthBox surface-bright">
            <div class="boxTitle">이달의 생일</div>
            <div class="birth-list">
                <c:forEach items="${birthdayList}" var="item">
                    <div class="birth-item">
                        <div class="birth-profile">
                            <div class="profile-img" style="background-image: url(${item.profileImg})"></div>
                            <div class="birth-info">
                                <div class="birth-name">${item.name} ${item.jobName}</div>
                                <div class="birth-dept">${item.departmentName}</div>
                            </div>
                        </div>
                        <div class="birth-date">
                            <fmt:formatDate value="${item.birthday}" pattern="MM월 dd일"/>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
<div class="detail-modal" id="eventDetailModal" style="display: none;">
    <div class="modal-container box surface-bright">
        <div class="modal-header box-title">
            <h2>일정 상세 정보</h2>
            <span class="material-icons" onclick="$('#eventDetailModal').hide();">close</span>
        </div>
        <div class="box-content">
            <div class="form-group">
                <label>제목</label>
                <div id="detail-title"></div>
            </div>
            <div class="form-group">
                <label>시작일</label>
                <div id="detail-start"></div>
            </div>
            <div class="form-group">
                <label>종료일</label>
                <div id="detail-end"></div>
            </div>
            <div class="form-group">
                <label>설명</label>
                <div id="detail-content"></div>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function() {
        // 날짜와 시간 표시 함수
        function updateDateTime() {
            const now = new Date();

            // 날짜 포맷팅
            const dateOptions = {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                weekday: 'long'
            };
            const dateStr = now.toLocaleDateString('ko-KR', dateOptions);

            // 시간 포맷팅
            const timeOptions = {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false
            };
            const timeStr = now.toLocaleTimeString('ko-KR', timeOptions);

            // jQuery로 HTML 업데이트
            $('.currentDate').text(dateStr);
            $('.currentTime').text(timeStr);
        }

        // 초기 실행
        updateDateTime();

        // 1초마다 업데이트
        setInterval(updateDateTime, 1000);

        // 출퇴근 버튼 클릭 이벤트 (필요한 경우)
        $('.startWork').click(function () {
            $.ajax({
                url: '/commute/workOn'
            }).done(function (data) {
                if (data) {
                    alert("출근하셨습니다.");
                    location.reload();
                }
            })
        });

        $('.endWork').click(function () {
            if(confirm("퇴근하시겠습니까?")) {
                $.ajax({
                    url: '/commute/workOff'
                }).done(function (data) {
                    if (data) {
                        alert("퇴근했습니다.");
                        location.reload();
                    }
                })
            }
        });

        $('.board-type-btn').click(function() {
            // 모든 버튼에서 active 클래스 제거
            $('.board-type-btn').removeClass('active');
            // 클릭된 버튼에만 active 클래스 추가
            $(this).addClass('active');
        });

        $('.category-btn').click(function() {
            // 모든 버튼에서 active 클래스 제거
            $('.category-btn').removeClass('active');
            // 클릭된 버튼에만 active 클래스 추가
            $(this).addClass('active');
        });
    });
</script>
<jsp:include page="/WEB-INF/views/template/footer.jsp" />