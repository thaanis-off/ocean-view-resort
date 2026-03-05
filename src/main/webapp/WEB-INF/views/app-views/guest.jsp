<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${guest != null ? 'Edit' : 'Add'} Guest — Ocean View Resort</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#f0f4ff',
                            100: '#e8f0fb',
                            500: '#1B4F8A',
                            600: '#163d6e',
                            700: '#0f2a4d'
                        }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-950 text-gray-100">
    <div class="flex h-screen overflow-hidden">
        
         <jsp:include page="/WEB-INF/includes/sidebar.jsp">
             <jsp:param name="activePage" value="guests" />
    		</jsp:include>

        <div class="flex-1 flex flex-col overflow-hidden">
            
            <header class="bg-gray-900 border-b border-gray-800 px-8 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <a href="${pageContext.request.contextPath}/guest?action=list" class="text-gray-400 hover:text-white transition-colors">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                        </a>
                        <div>
                            <h1 class="text-2xl font-bold text-white flex items-center">
                                ${guest != null ? 'Edit Guest' : 'Add New Guest'}
                                <span class="ml-3 px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-500/20 text-primary-400 border border-primary-500/30">
                                    ${guest != null ? 'Update Record' : 'New Registration'}
                                </span>
                            </h1>
                            <p class="text-sm text-gray-400 mt-1">Fill in the guest details below. Fields marked <span class="text-red-500">*</span> are required.</p>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4">
                        <span class="text-sm text-gray-400">Welcome, <strong class="text-white">${sessionScope.staffName}</strong></span>
                    </div>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                
                <div class="max-w-4xl mx-auto">
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="mb-6 p-4 rounded-lg bg-red-500/10 border border-red-500/20 text-red-400 flex items-center">
                            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            ${errorMessage}
                        </div>
                    </c:if>
                    <c:if test="${param.status == 'duplicate'}">
                        <div class="mb-6 p-4 rounded-lg bg-red-500/10 border border-red-500/20 text-red-400 flex items-center">
                            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            A guest with this email or NIC/Passport already exists.
                        </div>
                    </c:if>

                    <div class="bg-gray-900 border border-gray-800 rounded-xl shadow-lg p-8">
                        <form action="${pageContext.request.contextPath}/guest" method="post" class="space-y-8">
                            <input type="hidden" name="action" value="${guest != null ? 'update' : 'create'}">
                            <c:if test="${guest != null}">
                                <input type="hidden" name="id" value="${guest.id}">
                            </c:if>

                            <div>
                                <h3 class="text-lg font-semibold text-white border-b border-gray-800 pb-3 mb-6">Personal Information</h3>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">First Name <span class="text-red-500">*</span></label>
                                        <input type="text" name="firstName" value="${guest != null ? guest.firstName : param.firstName}" placeholder="e.g. James" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Last Name <span class="text-red-500">*</span></label>
                                        <input type="text" name="lastName" value="${guest != null ? guest.lastName : param.lastName}" placeholder="e.g. Wilson" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                    </div>
                                </div>

                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Gender <span class="text-red-500">*</span></label>
                                        <select name="gender" required class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                                            <option value="" class="bg-gray-900">-- Select --</option>
                                            <option value="Male" ${(guest != null && guest.gender == 'Male') || param.gender == 'Male' ? 'selected' : ''} class="bg-gray-900">Male</option>
                                            <option value="Female" ${(guest != null && guest.gender == 'Female') || param.gender == 'Female' ? 'selected' : ''} class="bg-gray-900">Female</option>
                                            <option value="Other" ${(guest != null && guest.gender == 'Other') || param.gender == 'Other' ? 'selected' : ''} class="bg-gray-900">Other</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Date of Birth</label>
                                        <input type="date" name="dateOfBirth" value="${guest != null ? guest.dateOfBirth : param.dateOfBirth}"
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors [color-scheme:dark]">
                                    </div>
                                </div>

                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">NIC / Passport Number</label>
                                        <input type="text" name="nicPassport" value="${guest != null ? guest.nicPassport : param.nicPassport}" placeholder="e.g. 987654321V"
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Nationality</label>
                                        <input type="text" name="nationality" value="${guest != null ? guest.nationality : param.nationality}" placeholder="e.g. Sri Lankan"
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                    </div>
                                </div>
                            </div>

                            <div>
                                <h3 class="text-lg font-semibold text-white border-b border-gray-800 pb-3 mb-6">Contact Information</h3>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Email Address <span class="text-red-500">*</span></label>
                                        <input type="email" name="email" value="${guest != null ? guest.email : param.email}" placeholder="e.g. james@email.com" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Phone Number <span class="text-red-500">*</span></label>
                                        <input type="tel" name="phone" value="${guest != null ? guest.phone : param.phone}" placeholder="e.g. +94771234567" required
                                            class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors">
                                    </div>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-400 mb-2">Address <span class="text-red-500">*</span></label>
                                    <textarea name="address" placeholder="Full mailing address" rows="3" required
                                        class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-3 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors resize-y">${guest != null ? guest.address : param.address}</textarea>
                                </div>
                            </div>

                            <div>
                                <h3 class="text-lg font-semibold text-white border-b border-gray-800 pb-3 mb-6">Guest Settings</h3>
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-2">Guest Type <span class="text-red-500">*</span></label>
                                        <select name="guestType" required class="w-full bg-gray-950 border border-gray-700 rounded-lg px-4 py-2.5 text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500 focus:outline-none transition-colors appearance-none">
                                            <option value="Regular" ${(guest != null && guest.guestType == 'Regular') || param.guestType == 'Regular' ? 'selected' : ''} class="bg-gray-900">Regular</option>
                                            <option value="VIP" ${(guest != null && guest.guestType == 'VIP') || param.guestType == 'VIP' ? 'selected' : ''} class="bg-gray-900">VIP</option>
                                            <option value="Corporate" ${(guest != null && guest.guestType == 'Corporate') || param.guestType == 'Corporate' ? 'selected' : ''} class="bg-gray-900">Corporate</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-medium text-gray-400 mb-3">Flags</label>
                                        <div class="flex flex-wrap gap-6 pt-1">
                                            <label class="flex items-center cursor-pointer group">
                                                <div class="relative flex items-center">
                                                    <input type="checkbox" name="isVip" ${(guest != null && guest.vip) || param.isVip == 'on' ? 'checked' : ''}
                                                        class="peer w-5 h-5 cursor-pointer appearance-none rounded border border-gray-600 bg-gray-950 checked:bg-yellow-500 checked:border-yellow-500 transition-all">
                                                    <svg class="absolute w-5 h-5 p-0.5 text-gray-900 opacity-0 peer-checked:opacity-100 pointer-events-none transition-opacity" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/></svg>
                                                </div>
                                                <span class="ml-3 text-sm text-gray-300 group-hover:text-white transition-colors">VIP Guest</span>
                                            </label>

                                            <label class="flex items-center cursor-pointer group">
                                                <div class="relative flex items-center">
                                                    <input type="checkbox" name="blacklisted" ${(guest != null && guest.blacklisted) || param.blacklisted == 'on' ? 'checked' : ''}
                                                        class="peer w-5 h-5 cursor-pointer appearance-none rounded border border-gray-600 bg-gray-950 checked:bg-red-500 checked:border-red-500 transition-all">
                                                    <svg class="absolute w-5 h-5 p-0.5 text-white opacity-0 peer-checked:opacity-100 pointer-events-none transition-opacity" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/></svg>
                                                </div>
                                                <span class="ml-3 text-sm text-gray-300 group-hover:text-white transition-colors">Blacklisted</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="pt-6 mt-6 border-t border-gray-800 flex items-center justify-end space-x-4">
                                <c:if test="${guest == null}">
                                    <button type="reset" class="px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors">
                                        Clear Form
                                    </button>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/guest?action=list" class="px-6 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors">
                                    Cancel
                                </a>
                               <button type="submit" class="px-6 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300">
								    ${guest != null ? 'Update Guest' : 'Save New Guest'}
								</button>
                            </div>

                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>