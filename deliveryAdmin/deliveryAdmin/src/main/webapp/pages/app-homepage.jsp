<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/includes/header.jsp" %>

        <main class="main-content bg-gray-50/50 min-h-screen">
            <div class="container-fluid px-6 py-8">

                <!-- Header -->
                <div class="mb-12 animate-fade-in-down">
                    <h1
                        class="text-4xl font-extrabold text-gray-900 tracking-tight mb-2 bg-clip-text text-transparent bg-gradient-to-r from-gray-900 to-indigo-900">
                        App Homepage</h1>
                    <p class="text-lg text-gray-500 font-medium max-w-2xl">Control the visual experience of your mobile
                        app's home screen. Manage banners, promotional videos, and featured content.</p>
                </div>

                <!-- Section 1: Normal Banners -->
                <section class="mb-16 animate-fade-in-up delay-100">
                    <div class="flex flex-col md:flex-row justify-between items-end mb-6">
                        <div class="flex items-center gap-3">
                            <div
                                class="w-10 h-10 rounded-xl bg-blue-100 text-blue-600 flex items-center justify-center">
                                <i class="fas fa-images text-lg"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-gray-900">Normal Banners</h2>
                                <p class="text-sm text-gray-500">Standard static banners for promotions.</p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 relative overflow-hidden">
                        <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6" id="normalBannersGrid">
                            <!-- Upload Card -->
                            <div class="aspect-[5/3] rounded-2xl border-2 border-dashed border-gray-200 hover:border-blue-500 bg-gray-50 hover:bg-blue-50/30 transition-all cursor-pointer group flex flex-col items-center justify-center text-center p-4"
                                onclick="document.getElementById('normalFileInput').click()">
                                <div
                                    class="w-12 h-12 rounded-full bg-white text-gray-400 group-hover:text-blue-500 shadow-sm flex items-center justify-center mb-3 transition-colors">
                                    <i class="fas fa-plus text-xl"></i>
                                </div>
                                <h4 class="font-bold text-gray-900 group-hover:text-blue-600 transition-colors">Add
                                    Banner</h4>
                                <p class="text-xs text-gray-400 mt-1">1200x600px recommended</p>
                            </div>
                        </div>
                        <input type="file" id="normalFileInput" hidden accept="image/*">
                    </div>
                </section>

                <!-- Section 2: Special Banners -->
                <section class="mb-12 animate-fade-in-up delay-200">
                    <div class="flex flex-col md:flex-row justify-between items-end mb-6">
                        <div class="flex items-center gap-3">
                            <div
                                class="w-10 h-10 rounded-xl bg-purple-100 text-purple-600 flex items-center justify-center">
                                <i class="fas fa-star text-lg"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-gray-900">Special Banners</h2>
                                <p class="text-sm text-gray-500">Interactive banners with video support.</p>
                            </div>
                        </div>

                        <div class="flex bg-white rounded-xl p-1 shadow-sm border border-gray-100">
                            <button
                                class="px-4 py-2 rounded-lg text-sm font-semibold transition-all bg-gray-100 text-gray-900"
                                id="typeImageBtn" onclick="setUploadType('image')">Image</button>
                            <button
                                class="px-4 py-2 rounded-lg text-sm font-semibold text-gray-500 hover:text-gray-900 transition-all"
                                id="typeVideoBtn" onclick="setUploadType('video')">Video</button>
                        </div>
                    </div>

                    <div
                        class="bg-gradient-to-br from-purple-50 to-white rounded-3xl p-8 shadow-sm border border-purple-100 relative overflow-hidden">
                        <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6" id="specialBannersGrid">
                            <!-- Upload Card -->
                            <div class="aspect-[4/5] rounded-2xl border-2 border-dashed border-purple-200 hover:border-purple-500 bg-white/50 hover:bg-purple-50 transition-all cursor-pointer group flex flex-col items-center justify-center text-center p-4"
                                onclick="document.getElementById('specialFileInput').click()">
                                <div
                                    class="w-14 h-14 rounded-full bg-white text-purple-300 group-hover:text-purple-500 shadow-sm flex items-center justify-center mb-3 transition-all transform group-hover:scale-110">
                                    <i class="fas fa-cloud-upload-alt text-2xl"></i>
                                </div>
                                <h4 class="font-bold text-gray-900 group-hover:text-purple-600 transition-colors">Upload
                                    Special</h4>
                                <p class="text-xs text-gray-400 mt-1" id="specialUploadText">Image or Video</p>
                            </div>
                        </div>
                        <!-- Independent Inputs -->
                        <input type="file" id="specialFileInput" hidden accept="image/*,video/*">
                    </div>
                </section>

            </div>
        </main>


        <!-- Video Preview Modal -->
        <div class="modal fade" id="videoModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content bg-transparent border-0 shadow-none">
                    <div class="relative bg-black rounded-3xl overflow-hidden shadow-2xl">
                        <button type="button"
                            class="absolute top-4 right-4 z-10 w-10 h-10 rounded-full bg-black/50 text-white hover:bg-black/70 flex items-center justify-center transition-colors backdrop-blur-md"
                            data-bs-dismiss="modal">
                            <i class="fas fa-times"></i>
                        </button>
                        <video id="modalVideoPlayer" controls class="w-full max-h-[80vh] block"></video>
                    </div>
                </div>
            </div>
        </div>

        <style>
            .animate-fade-in-down {
                animation: fadeInDown 0.8s ease-out;
            }

            .animate-fade-in-up {
                animation: fadeInUp 0.8s ease-out;
            }

            .delay-100 {
                animation-delay: 0.1s;
            }

            .delay-200 {
                animation-delay: 0.2s;
            }

            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Custom Switch */
            .toggle-checkbox:checked {
                right: 0;
                border-color: #68D391;
            }

            .toggle-checkbox:checked+.toggle-label {
                background-color: #68D391;
            }
        </style>

        <%@ include file="/includes/footer.jsp" %>
            <script src="${pageContext.request.contextPath}/resources/js/app-homepage.js"></script>