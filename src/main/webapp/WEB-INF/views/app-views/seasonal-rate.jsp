<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${rate != null ? 'Edit' : 'Add'} Seasonal Rate — Ocean View Resort</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter', 'sans-serif'] },
                    colors: {
                        primary: {
                            50: '#f0f4ff', 100: '#e8f0fb',
                            500: '#1B4F8A', 600: '#163d6e', 700: '#0f2a4d'
                        }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-950 text-gray-100">
    <c:if test="${empty sessionScope.loggedInStaff}">
        <c:redirect url="/login?status=sessionExpired"/>
    </c:if>
    
    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/includes/sidebar.jsp">
             <jsp:param name="activePage" value="seasonalrates" />
    		</jsp:include>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/room?action=list" class="text-gray-400 hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                        </a>
                        <div>
                            <h1 class="text-2xl font-bold text-white flex items-center">
                                ${rate != null ? 'Edit Seasonal Rates' : 'Add Seasonal Rates'}
                                <span class="ml-3 px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-500/20 text-primary-400 border border-primary-500/30">
                                    ${rate != null ? 'Update Seasonal Rates' : 'New Seasonal Rates'}
                                </span>
                            </h1>
                            <p class="text-sm text-gray-400 mt-1">Configure dynamic pricing for peak and off-peak seasons <span class="text-red-500">*</span> are required.</p>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4">
                        <span class="text-sm text-gray-400">Welcome, <strong class="text-white">${sessionScope.staffName}</strong></span>
                    </div>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                <div class="max-w-4xl mx-auto">
                    <!-- Info Banner -->
                    <div class="bg-blue-500/10 border border-blue-500/30 rounded-lg p-4 mb-6 flex items-start space-x-3">
                        <svg class="w-5 h-5 text-blue-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <div>
                            <p class="text-sm text-blue-300 font-medium">Seasonal Rate Configuration</p>
                            <p class="text-xs text-blue-400/80 mt-1">Set special pricing for specific time periods. Active rates will automatically apply to new reservations during the specified dates.</p>
                        </div>
                    </div>

					<c:if test="${not empty errorMessage}">
					    <div class="mb-6 bg-red-500/10 border border-red-500/30 rounded-lg p-4 flex items-start space-x-3">
					        <svg class="w-5 h-5 text-red-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
					        </svg>
					        <div>
					            <p class="text-sm text-red-300 font-medium">Validation Error</p>
					            <p class="text-xs text-red-400/80 mt-1">${errorMessage}</p>
					        </div>
					    </div>
					</c:if>
                    <!-- Form -->
                    <form action="${pageContext.request.contextPath}/seasonalRates" method="post" class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                        <input type="hidden" name="action" value="${rate != null ? 'update' : 'create'}">
                        <c:if test="${rate != null}">
                            <input type="hidden" name="id" value="${rate.id}">
                        </c:if>

                        <!-- Season Details -->
                        <div class="mb-8">
                            <h3 class="text-lg font-semibold text-white mb-4 pb-2 border-b border-gray-800">Season Details</h3>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <!-- Season Name -->
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-medium text-gray-300 mb-2">
                                        Season Name <span class="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="seasonName" value="${rate != null ? rate.seasonName : ''}" 
                                        placeholder="e.g., Summer Peak 2026, Christmas Holiday"
                                        required
                                        class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none">
                                    <p class="text-xs text-gray-500 mt-1">Give this rate a descriptive name for easy identification</p>
                                </div>

                                <!-- Room Type -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-300 mb-2">
                                        Room Type <span class="text-red-500">*</span>
                                    </label>
                                    <select name="roomTypeId" required class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                                         <option value="" class="bg-gray-900">-- Select Room Type --</option>
                                         <c:forEach var="type" items="${roomTypes}">
                                             <option value="${type.id}" ${(rate != null && rate.roomTypeId == type.id) || param.roomTypeId == type.id ? 'selected' : ''} class="bg-gray-900">
                                                 ${type.typeName}
                                             </option>
                                         </c:forEach>
                                     </select>
                                     <p class="text-xs text-gray-500 mt-1.5">Select the room category</p>
                                </div>

                                <!-- Active Status -->
                                <div class="flex items-center h-full pt-8">
                                    <label class="flex items-center space-x-3 cursor-pointer">
                                        <input type="checkbox" name="isActive" id="isActive" 
                                            ${rate == null || rate.active ? 'checked' : ''}
                                            class="w-5 h-5 bg-gray-950 border-gray-700 rounded text-primary-500 focus:ring-2 focus:ring-primary-500 focus:ring-offset-0 focus:ring-offset-gray-900">
                                        <span class="text-sm font-medium text-gray-300">
                                            <span class="text-green-400">●</span> Active (Auto-apply to bookings)
                                        </span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Date Range -->
                        <div class="mb-8">
                            <h3 class="text-lg font-semibold text-white mb-4 pb-2 border-b border-gray-800">Date Range</h3>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
							    <div>
							        <label class="block text-sm font-medium text-gray-300 mb-2">
							            Start Date <span class="text-red-500">*</span>
							        </label>
							        <input type="date" 
							               name="startDate" 
							               id="startDate"
							               value="${rate != null ? rate.startDate : ''}"
							               required
							               min="${currentDate}"
							               onchange="validateStartDate()"
							               class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none [color-scheme:dark]">
							        <p id="startDateError" class="text-red-400 text-xs mt-1 hidden"></p>
							    </div>
							
							    <div>
							        <label class="block text-sm font-medium text-gray-300 mb-2">
							            End Date <span class="text-red-500">*</span>
							        </label>
							        <input type="date" 
							               name="endDate" 
							               id="endDate"
							               value="${rate != null ? rate.endDate : ''}"
							               required
							               min="${currentDate}"
							               onchange="validateEndDate()"
							               class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg px-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none [color-scheme:dark]">
							        <p id="endDateError" class="text-red-400 text-xs mt-1 hidden"></p>
							    </div>
							</div>
                        </div>

                        <!-- Pricing -->
                        <div class="mb-8">
                            <h3 class="text-lg font-semibold text-white mb-4 pb-2 border-b border-gray-800">Pricing</h3>
                            
                            <div class="grid grid-cols-1 md:grid-cols-1">
                                <!-- Special Price -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-300 mb-2">
                                        Special Price Per Night <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400">$</span>
                                        <input type="number" step="0.01" name="pricePerNight" 
                                            value="${rate != null ? rate.pricePerNight : ''}" 
                                            placeholder="0.00"
                                            required
                                            class="w-full bg-gray-950 border border-gray-700 text-gray-300 rounded-lg pl-8 pr-4 py-2.5 focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none">
                                    </div>
                                    <p class="text-xs text-gray-500 mt-1">Price that will apply during this season</p>
                                </div>

                                <!-- Discount Percentage -->
                              
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="flex items-center gap-4 pt-4 border-t border-gray-800">
                            <button type="submit" 
                                class="px-6 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg transition-all">
                                <svg class="w-5 h-5 inline-block mr-2 -mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                </svg>
                                 ${rate != null ? 'Update Seasonal Rates' : 'Save New Seasonal Rates'}
                            </button>
                            <a href="${pageContext.request.contextPath}/seasonalRates?action=list" 
                                class="px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
    
    <script>
    const today = new Date();
    const todayString = today.toISOString().split('T')[0];
    
    document.getElementById('startDate').min = todayString;
    document.getElementById('endDate').min = todayString;

    function validateStartDate() {
        const startDateInput = document.getElementById('startDate');
        const endDateInput = document.getElementById('endDate');
        const startDateError = document.getElementById('startDateError');
        
        const startDate = new Date(startDateInput.value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        startDateError.classList.add('hidden');
        startDateInput.classList.remove('border-red-500');
        
        if (startDate < today) {
            startDateError.textContent = 'Start date cannot be in the past';
            startDateError.classList.remove('hidden');
            startDateInput.classList.add('border-red-500');
            startDateInput.value = '';
            return false;
        }
        
        if (startDateInput.value) {
            endDateInput.min = startDateInput.value;
            if (endDateInput.value) {
                validateEndDate();
            }
        }
        
        return true;
    }

    function validateEndDate() {
        const startDateInput = document.getElementById('startDate');
        const endDateInput = document.getElementById('endDate');
        const endDateError = document.getElementById('endDateError');
        
        const startDate = new Date(startDateInput.value);
        const endDate = new Date(endDateInput.value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        endDateError.classList.add('hidden');
        endDateInput.classList.remove('border-red-500');
        
        if (endDate < today) {
            endDateError.textContent = 'End date cannot be in the past';
            endDateError.classList.remove('hidden');
            endDateInput.classList.add('border-red-500');
            endDateInput.value = '';
            return false;
        }
        
        if (startDateInput.value && endDate < startDate) {
            endDateError.textContent = 'End date must be on or after start date';
            endDateError.classList.remove('hidden');
            endDateInput.classList.add('border-red-500');
            endDateInput.value = '';
            return false;
        }
        
        if (startDateInput.value) {
            const daysDiff = Math.floor((endDate - startDate) / (1000 * 60 * 60 * 24));
            if (daysDiff > 365) {
                endDateError.textContent = 'Seasonal rate cannot exceed 365 days';
                endDateError.classList.remove('hidden');
                endDateInput.classList.add('border-red-500');
                endDateInput.value = '';
                return false;
            }
        }
        
        return true;
    }

    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        if (form) {
            form.addEventListener('submit', function(e) {
                if (!validateStartDate() || !validateEndDate()) {
                    e.preventDefault();
                    alert('Please fix the date validation errors');
                    return false;
                }
            });
        }
    });
</script>

</body>
</html>