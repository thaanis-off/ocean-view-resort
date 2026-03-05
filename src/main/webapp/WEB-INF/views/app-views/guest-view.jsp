<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guest Details — Ocean View Resort</title>
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
                            <h1 class="text-2xl font-bold text-white">Guest Profile</h1>
                            <p class="text-sm text-gray-400 mt-1">Detailed information for ${guest.fullName}</p>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4">
                        <span class="text-sm text-gray-400">Welcome, <strong class="text-white">${sessionScope.staffName}</strong></span>
                    </div>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto bg-gray-950 p-8">
                <div class="max-w-6xl mx-auto space-y-6">

                    <div class="bg-gradient-to-br from-primary-600 to-gray-900 rounded-xl p-8 shadow-lg border border-primary-500/30 flex flex-col md:flex-row items-center md:items-start gap-6">
                        <div class="w-24 h-24 rounded-full bg-white/10 flex items-center justify-center text-3xl font-bold text-white shadow-inner flex-shrink-0 border border-white/20">
                            ${guest.firstName.charAt(0)}${guest.lastName.charAt(0)}
                        </div>
                        <div class="text-center md:text-left flex-1">
                            <h2 class="text-3xl font-bold text-white">${guest.fullName}</h2>
                            <div class="mt-2 flex flex-col md:flex-row md:items-center space-y-2 md:space-y-0 md:space-x-4 text-primary-100 text-sm">
                                <span class="flex items-center justify-center md:justify-start">
                                    <svg class="w-4 h-4 mr-1.5 opacity-80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2"/></svg>
                                    ${guest.guestCode}
                                </span>
                                <span class="hidden md:inline text-white/40">|</span>
                                <span class="flex items-center justify-center md:justify-start">
                                    <svg class="w-4 h-4 mr-1.5 opacity-80" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                                    ${guest.email}
                                </span>
                            </div>
                            <div class="mt-4 flex flex-wrap justify-center md:justify-start gap-2">
                                <c:choose>
                                    <c:when test="${guest.blacklisted}">
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-red-500/20 text-red-300 border border-red-500/30">🚫 Blacklisted</span>
                                    </c:when>
                                    <c:when test="${guest.guestType == 'VIP'}">
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-yellow-500/20 text-yellow-300 border border-yellow-500/30">⭐ VIP Guest</span>
                                    </c:when>
                                    <c:when test="${guest.guestType == 'Corporate'}">
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-500/20 text-blue-300 border border-blue-500/30">🏢 Corporate</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-white/10 text-white border border-white/20">Regular Guest</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6">
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center">
                            <div class="text-3xl font-bold text-primary-400">${guest.totalStays}</div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-1">Total Stays</div>
                        </div>
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center">
                            <div class="text-2xl font-bold text-primary-400 mt-1">${guest.guestType}</div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Guest Type</div>
                        </div>
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center">
                            <div class="text-2xl font-bold mt-1 ${guest.vip ? 'text-yellow-500' : 'text-gray-500'}">
                                ${guest.vip ? '⭐ Yes' : 'No'}
                            </div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">VIP Status</div>
                        </div>
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-5 text-center">
                            <div class="text-2xl font-bold mt-1 ${guest.blacklisted ? 'text-red-500' : 'text-green-500'}">
                                ${guest.blacklisted ? '🚫 Yes' : '✅ No'}
                            </div>
                            <div class="text-xs text-gray-400 font-medium uppercase tracking-wider mt-2">Blacklisted</div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        
                        <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                            <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">Personal Information</h3>
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">First Name</label>
                                    <div class="text-sm text-gray-200 mt-1">${guest.firstName}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Last Name</label>
                                    <div class="text-sm text-gray-200 mt-1">${guest.lastName}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Gender</label>
                                    <div class="text-sm text-gray-200 mt-1">${not empty guest.gender ? guest.gender : '—'}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Date of Birth</label>
                                    <div class="text-sm text-gray-200 mt-1">${not empty guest.dateOfBirth ? guest.dateOfBirth : '—'}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">NIC / Passport</label>
                                    <div class="text-sm text-gray-200 mt-1">${not empty guest.nicPassport ? guest.nicPassport : '—'}</div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-gray-500 uppercase">Nationality</label>
                                    <div class="text-sm text-gray-200 mt-1">${not empty guest.nationality ? guest.nationality : '—'}</div>
                                </div>
                            </div>
                        </div>

                        <div class="space-y-6">
                            
                            <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                                <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">Contact Information</h3>
                                <div class="space-y-4">
                                    <div>
                                        <label class="block text-xs font-semibold text-gray-500 uppercase">Email Address</label>
                                        <div class="text-sm text-gray-200 mt-1">${guest.email}</div>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-gray-500 uppercase">Phone Number</label>
                                        <div class="text-sm text-gray-200 mt-1">${guest.phone}</div>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-gray-500 uppercase">Address</label>
                                        <div class="text-sm text-gray-200 mt-1 leading-relaxed">${guest.address}</div>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-gray-900 border border-gray-800 rounded-xl p-6">
                                <h3 class="text-sm font-bold text-primary-400 uppercase tracking-wider border-b border-gray-800 pb-3 mb-5">System Information</h3>
                                <div class="space-y-4">
                                    <div>
                                        <label class="block text-xs font-semibold text-gray-500 uppercase">Guest Code</label>
                                        <div class="text-sm font-mono text-gray-200 mt-1">${guest.guestCode}</div>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-gray-500 uppercase">Registered On</label>
                                        <div class="text-sm text-gray-200 mt-1">${not empty guest.createdAt ? guest.createdAt : '—'}</div>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-gray-500 uppercase">Account Status</label>
                                        <div class="flex items-center mt-1">
                                            <span class="w-2.5 h-2.5 rounded-full mr-2 ${guest.active ? 'bg-green-500' : 'bg-gray-500'}"></span>
                                            <span class="text-sm text-gray-200">${guest.active ? 'Active' : 'Inactive'}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 flex flex-wrap items-center justify-end gap-4 mt-6">
                        <a href="${pageContext.request.contextPath}/guest?action=list" class="px-5 py-2.5 bg-gray-800 hover:bg-gray-700 text-gray-300 font-medium rounded-lg border border-gray-700 transition-colors mr-auto">
                            ← Back to List
                        </a>

                        <a href="${pageContext.request.contextPath}/guest?action=edit&id=${guest.id}" 
   class="inline-flex items-center px-5 py-2.5 bg-gradient-to-br from-primary-600 to-gray-900 hover:from-primary-500 hover:to-gray-800 border border-primary-500/30 text-white font-medium rounded-lg shadow-md transition-all duration-300">
    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg>
    Edit Profile
</a>

                        <c:choose>
                            <c:when test="${guest.blacklisted}">
                                <a href="${pageContext.request.contextPath}/guest?action=toggleBlacklist&id=${guest.id}&blacklisted=false" class="px-5 py-2.5 bg-green-500/10 hover:bg-green-500/20 border border-green-500/50 text-green-400 font-medium rounded-lg transition-colors flex items-center">
                                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                    Remove Blacklist
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/guest?action=toggleBlacklist&id=${guest.id}&blacklisted=true" onclick="return confirm('Are you sure you want to blacklist ${guest.fullName}?')" class="px-5 py-2.5 bg-orange-500/10 hover:bg-orange-500/20 border border-orange-500/50 text-orange-400 font-medium rounded-lg transition-colors flex items-center">
                                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636"/></svg>
                                    Blacklist Guest
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <button onclick="confirmDelete(${guest.id}, '${guest.fullName}')" class="px-5 py-2.5 bg-red-500 hover:bg-red-600 text-white font-medium rounded-lg transition-colors flex items-center">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                            Delete
                        </button>
                    </div>

                </div>
            </main>
        </div>
    </div>

    <script>
        function confirmDelete(id, name) {
            if (confirm('Permanently delete guest: ' + name + '?\nThis cannot be undone.')) {
                window.location = '${pageContext.request.contextPath}/guest?action=delete&id=' + id;
            }
        }
    </script>
</body>
</html>