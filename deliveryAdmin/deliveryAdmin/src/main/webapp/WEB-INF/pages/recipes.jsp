<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/includes/header.jsp" %>

        <main class="main-content bg-gray-50/50 min-h-screen">
            <div class="container-fluid px-6 py-8">
                <!-- Header -->
                <div class="flex flex-col md:flex-row justify-between items-end mb-10 animate-fade-in-down">
                    <div>
                        <h1
                            class="text-4xl font-extrabold text-gray-900 tracking-tight mb-2 bg-clip-text text-transparent bg-gradient-to-r from-gray-900 to-gray-600">
                            Recipes Collection</h1>
                        <p class="text-lg text-gray-500 font-medium">Curate and manage your culinary masterpieces.</p>
                    </div>

                    <button
                        class="group inline-flex items-center justify-center px-8 py-3 font-semibold text-white transition-all duration-200 bg-indigo-600 rounded-full hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-600 shadow-lg hover:shadow-xl hover:-translate-y-0.5"
                        data-bs-toggle="modal" data-bs-target="#recipeModal" onclick="prepareAddRecipe()">
                        <i class="fas fa-plus mr-2 text-sm group-hover:rotate-90 transition-transform duration-300"></i>
                        <span>Create Recipe</span>
                    </button>
                </div>

                <!-- Search & Filters -->
                <div class="mb-10 animate-fade-in-up delay-100">
                    <div class="relative max-w-2xl mx-auto md:mx-0 group">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <i
                                class="fas fa-search text-gray-400 group-focus-within:text-indigo-500 transition-colors duration-300"></i>
                        </div>
                        <input type="text" id="recipeSearch"
                            class="block w-full pl-11 pr-4 py-4 bg-white border-0 rounded-2xl text-gray-900 placeholder-gray-400 focus:ring-2 focus:ring-indigo-500/20 shadow-sm hover:shadow-md focus:shadow-xl transition-all duration-300 text-base font-medium"
                            placeholder="Search by name, ingredients, or category...">
                        <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                            <kbd
                                class="hidden md:inline-block border border-gray-200 rounded px-2 text-xs font-medium text-gray-400">Ctrl
                                K</kbd>
                        </div>
                    </div>
                </div>

                <!-- Grid -->
                <div id="recipesGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8 pb-20">
                    <!-- JS Injected -->
                </div>

            </div>
        </main>


        <!-- Recipe Modal -->
        <div class="modal fade" id="recipeModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
            <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content border-0 shadow-2xl rounded-3xl overflow-hidden bg-white">
                    <div class="modal-header border-b border-gray-100 p-6 bg-white sticky top-0 z-10">
                        <div>
                            <h5 class="text-2xl font-bold text-gray-900" id="modalTitle">Add Recipe</h5>
                            <p class="text-sm text-gray-500 mt-1">Fill in the details to create a new culinary entry.
                            </p>
                        </div>
                        <button type="button"
                            class="w-10 h-10 rounded-full bg-gray-50 text-gray-400 hover:text-gray-900 hover:bg-gray-100 flex items-center justify-center transition-all duration-200 focus:outline-none"
                            data-bs-dismiss="modal">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>

                    <div class="modal-body p-0">
                        <form id="recipeForm" class="flex flex-col lg:flex-row h-full">
                            <input type="hidden" id="recipeId">

                            <!-- Left Sidebar (Image & Basics) -->
                            <div class="w-full lg:w-1/3 bg-gray-50/80 p-8 border-r border-gray-100 space-y-8">
                                <div>
                                    <label
                                        class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-3 ml-1">Cover
                                        Image</label>
                                    <div class="relative group w-full aspect-[3/4] rounded-2xl bg-white border-2 border-dashed border-gray-300 hover:border-indigo-500 transition-all duration-300 cursor-pointer overflow-hidden shadow-sm hover:shadow-md"
                                        onclick="document.getElementById('recipeFileInput').click()">
                                        <img id="recipeImagePreview" src=""
                                            class="w-full h-full object-cover hidden transition-transform duration-700 group-hover:scale-105">
                                        <div id="recipeImagePlaceholder"
                                            class="absolute inset-0 flex flex-col items-center justify-center text-center p-6 transition-opacity duration-300 group-hover:opacity-50">
                                            <div
                                                class="w-16 h-16 rounded-2xl bg-indigo-50 text-indigo-500 flex items-center justify-center mb-4 shadow-sm group-hover:scale-110 transition-transform duration-300">
                                                <i class="fas fa-cloud-upload-alt text-2xl"></i>
                                            </div>
                                            <p class="text-sm font-semibold text-gray-900">Upload Cover</p>
                                            <p class="text-xs text-gray-500 mt-1">PNG, JPG up to 5MB</p>
                                        </div>
                                        <div
                                            class="absolute inset-0 bg-black/40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300 backdrop-blur-sm">
                                            <span
                                                class="px-4 py-2 bg-white/20 text-white rounded-lg backdrop-blur-md border border-white/30 text-sm font-medium">Change
                                                Image</span>
                                        </div>
                                    </div>
                                    <input type="file" id="recipeFileInput" hidden accept="image/*">
                                </div>

                                <div class="space-y-5">
                                    <div>
                                        <label
                                            class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2 ml-1">Prep
                                            Time</label>
                                        <div class="relative">
                                            <i
                                                class="fas fa-clock absolute left-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                                            <input type="number" id="recipeTime" class="form-input-premium pl-10"
                                                placeholder="e.g. 45" required>
                                            <span
                                                class="absolute right-4 top-1/2 -translate-y-1/2 text-xs font-medium text-gray-400">mins</span>
                                        </div>
                                    </div>
                                    <div>
                                        <label
                                            class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2 ml-1">Rating</label>
                                        <div class="relative">
                                            <i
                                                class="fas fa-star absolute left-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                                            <input type="number" id="recipeRating" class="form-input-premium pl-10"
                                                placeholder="0.0 - 5.0" step="0.1" max="5" required>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Content (Details & Lists) -->
                            <div class="w-full lg:w-2/3 p-8 space-y-8 bg-white">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div class="md:col-span-2">
                                        <label class="label-heading">Recipe Title</label>
                                        <input type="text" id="recipeName"
                                            class="form-input-premium text-lg font-semibold"
                                            placeholder="e.g. Authentic Butter Chicken" required>
                                    </div>

                                    <!-- CUSTOM CATEGORY INPUT -->
                                    <div class="md:col-span-2">
                                        <label class="label-heading">Category</label>
                                        <input type="text" id="recipeCategory" class="form-input-premium mb-3"
                                            placeholder="Type or select a category" list="categoryOptions">

                                        <!-- Quick Select Pills -->
                                        <div class="flex flex-wrap gap-2">
                                            <button type="button" onclick="setCategory(this.innerText)"
                                                class="cat-pill-quick">Chicken</button>
                                            <button type="button" onclick="setCategory(this.innerText)"
                                                class="cat-pill-quick">Mutton</button>
                                            <button type="button" onclick="setCategory(this.innerText)"
                                                class="cat-pill-quick">Seafood</button>
                                            <button type="button" onclick="setCategory(this.innerText)"
                                                class="cat-pill-quick">Vegetarian</button>
                                            <button type="button" onclick="setCategory(this.innerText)"
                                                class="cat-pill-quick">Exotic</button>
                                            <button type="button" onclick="setCategory(this.innerText)"
                                                class="cat-pill-quick">Desert</button>
                                            <button type="button" onclick="setCategory(this.innerText)"
                                                class="cat-pill-quick">Snacks</button>
                                        </div>
                                    </div>

                                    <div class="md:col-span-2">
                                        <label class="label-heading">Description</label>
                                        <textarea id="recipeDesc"
                                            class="form-input-premium min-h-[100px] resize-none leading-relaxed"
                                            placeholder="Describe the flavors, textures, and story behind this dish..."></textarea>
                                    </div>
                                </div>

                                <!-- Dynamic Lists -->
                                <div class="grid grid-cols-1 gap-8">
                                    <!-- Ingredients -->
                                    <div class="bg-gray-50/50 rounded-2xl p-6 border border-gray-100">
                                        <div class="flex justify-between items-center mb-4">
                                            <div class="flex items-center gap-2">
                                                <div
                                                    class="w-8 h-8 rounded-lg bg-orange-100 text-orange-600 flex items-center justify-center">
                                                    <i class="fas fa-carrot text-sm"></i>
                                                </div>
                                                <h6 class="font-bold text-gray-900">Ingredients</h6>
                                            </div>
                                            <button type="button" onclick="addIngredient()"
                                                class="text-xs font-bold text-indigo-600 hover:text-white hover:bg-indigo-600 bg-white border border-indigo-100 px-3 py-1.5 rounded-full transition-all duration-200 shadow-sm">+
                                                Add Item</button>
                                        </div>
                                        <div id="ingredientsList" class="space-y-3"></div>
                                    </div>

                                    <!-- Steps -->
                                    <div class="bg-gray-50/50 rounded-2xl p-6 border border-gray-100">
                                        <div class="flex justify-between items-center mb-4">
                                            <div class="flex items-center gap-2">
                                                <div
                                                    class="w-8 h-8 rounded-lg bg-green-100 text-green-600 flex items-center justify-center">
                                                    <i class="fas fa-list-ol text-sm"></i>
                                                </div>
                                                <h6 class="font-bold text-gray-900">Preparation Steps</h6>
                                            </div>
                                            <button type="button" onclick="addStep()"
                                                class="text-xs font-bold text-indigo-600 hover:text-white hover:bg-indigo-600 bg-white border border-indigo-100 px-3 py-1.5 rounded-full transition-all duration-200 shadow-sm">+
                                                Add Step</button>
                                        </div>
                                        <div id="stepsList" class="space-y-3"></div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div
                        class="modal-footer bg-white border-t border-gray-100 p-6 flex justify-between items-center sticky bottom-0 z-10">
                        <button type="button"
                            class="px-6 py-2.5 rounded-xl text-gray-500 hover:bg-gray-50 font-semibold transition-colors duration-200"
                            data-bs-dismiss="modal">Cancel</button>
                        <div class="flex gap-3">
                            <button type="button" onclick="saveRecipe()"
                                class="px-8 py-2.5 rounded-xl bg-indigo-600 text-white font-semibold shadow-lg shadow-indigo-200 hover:bg-indigo-700 hover:shadow-xl hover:-translate-y-0.5 transition-all duration-200 flex items-center gap-2">
                                <i class="fas fa-check"></i> Save Recipe
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <style>
            .animate-fade-in-down {
                animation: fadeInDown 0.6s ease-out;
            }

            .animate-fade-in-up {
                animation: fadeInUp 0.6s ease-out;
            }

            .delay-100 {
                animation-delay: 0.1s;
            }

            .text-shadow-sm {
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
            }

            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }

                <style>

                /* Premium Animation Keyframes */
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

                .animate-fade-in-down {
                    animation: fadeInDown 0.6s ease-out forwards;
                }

                .animate-fade-in-up {
                    animation: fadeInUp 0.6s ease-out forwards;
                }

                .delay-100 {
                    animation-delay: 0.1s;
                }

                .delay-200 {
                    animation-delay: 0.2s;
                }

                /* Custom Form Styling (Fallback/Enhancement) */
                .form-input-premium {
                    display: block;
                    width: 100%;
                    padding: 0.75rem 1rem;
                    background-color: #fff;
                    border: 1px solid #e5e7eb;
                    border-radius: 0.75rem;
                    font-size: 0.95rem;
                    color: #1f2937;
                    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
                    box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                }

                .form-input-premium:focus {
                    border-color: #6366f1;
                    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
                    /* Indigo glow */
                    outline: none;
                }

                /* Category Pill */
                .cat-pill {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 0.5rem;
                    border-radius: 0.75rem;
                    background-color: #fff;
                    border: 1px solid #e5e7eb;
                    color: #6b7280;
                    cursor: pointer;
                    font-size: 0.875rem;
                    font-weight: 600;
                    transition: all 0.2s;
                    user-select: none;
                }

                /* Checked States manual overrides to ensure visibility */
                input[type="radio"]:checked+.cat-pill {
                    background-color: #eef2ff;
                    color: #4f46e5;
                    border-color: #c7d2fe;
                    box-shadow: 0 2px 4px rgba(99, 102, 241, 0.1);
                }

                /* Layout Fixes */
                .modal-body {
                    max-height: 80vh;
                    overflow-y: auto;
                }

                /* Grid Fallback */
                #recipesGrid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                    gap: 2rem;
                }

                /* Card Styles */
                .group.bg-white {
                    background: #fff;
                    border-radius: 1.5rem;
                    border: 1px solid #f3f4f6;
                    transition: transform 0.3s ease, box-shadow 0.3s ease;
                }

                .group.bg-white:hover {
                    transform: translateY(-4px);
                    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                }

                /* Quick Category Pills */
                .cat-pill-quick {
                    padding: 0.4rem 0.8rem;
                    border-radius: 9999px;
                    background-color: #f3f4f6;
                    color: #4b5563;
                    font-size: 0.8rem;
                    font-weight: 600;
                    border: 1px solid transparent;
                    transition: all 0.2s;
                }

                .cat-pill-quick:hover {
                    background-color: #e5e7eb;
                    color: #111827;
                    transform: translateY(-1px);
                }
        </style>

        <%@ include file="/includes/footer.jsp" %>
            <script src="${pageContext.request.contextPath}/resources/js/recipes.js"></script>