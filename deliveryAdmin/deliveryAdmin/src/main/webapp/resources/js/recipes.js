document.addEventListener('DOMContentLoaded', () => {

    // --- Mock Data ---
    let recipes = [
        {
            id: 'r1',
            name: 'Spicy Chicken Curry',
            category: 'Chicken',
            imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
            time: '45',
            rating: 4.8,
            desc: 'A rich and spicy curry made with roasted spices, perfect for a hearty family dinner.',
            ingredients: ['500g Chicken', '2 Onions', '1 tbsp Ginger Garlic Paste', '2 Tomatoes', '1 tsp Turmeric'],
            steps: ['Marinate chicken with spices', 'Fry onions until golden brown', 'Add tomatoes and cook until soft', 'Add chicken and simmer for 30 mins']
        },
        {
            id: 'r2',
            name: 'Grilled Mutton Chops',
            category: 'Mutton',
            imageUrl: 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?auto=format&fit=crop&w=600&q=80',
            time: '60',
            rating: 4.5,
            desc: 'Juicy mutton chops marinated in yogurt and spices, then grilled to smoky perfection.',
            ingredients: ['Mutton Chops', 'Yogurt', 'Spices', 'Lemon Juice'],
            steps: ['Marinate chops overnight for best results', 'Preheat grill to high heat', 'Grill for 10-15 mins per side']
        }
    ];

    // --- DOM ---
    const grid = document.getElementById('recipesGrid');
    const searchInput = document.getElementById('recipeSearch');
    const modalEl = document.getElementById('recipeModal');
    let bootstrapModal = null;
    if (modalEl) bootstrapModal = new bootstrap.Modal(modalEl);

    // Form Inputs
    const fId = document.getElementById('recipeId');
    const fName = document.getElementById('recipeName');
    const fTime = document.getElementById('recipeTime');
    const fRating = document.getElementById('recipeRating');
    const fDesc = document.getElementById('recipeDesc');
    const fImgPreview = document.getElementById('recipeImagePreview');
    const fImgPlaceholder = document.getElementById('recipeImagePlaceholder');
    const fFile = document.getElementById('recipeFileInput');

    // Lists
    const listIngredients = document.getElementById('ingredientsList');
    const listSteps = document.getElementById('stepsList');


    // --- Init ---
    renderAll();

    searchInput.addEventListener('input', renderAll);
    fFile.addEventListener('change', function () {
        if (this.files && this.files[0]) {
            const url = URL.createObjectURL(this.files[0]);
            showPreview(url);
        }
    });


    // --- Core Logic ---

    function renderAll() {
        const term = searchInput.value.toLowerCase();
        const filtered = recipes.filter(r => r.name.toLowerCase().includes(term) || r.category.toLowerCase().includes(term));

        if (!filtered.length) {
            grid.innerHTML = `
                <div class="col-span-full py-20 text-center">
                    <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4 animate-bounce">
                        <i class="fas fa-search text-gray-300 text-3xl"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-2">No recipes found</h3>
                    <p class="text-gray-500">Try adjusting your search terms or add a new recipe.</p>
                </div>
            `;
            return;
        }

        grid.innerHTML = filtered.map((r, idx) => `
            <div class="group bg-white rounded-[2rem] shadow-sm border border-gray-100 hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 flex flex-col h-full overflow-hidden animate-fade-in-up" style="animation-delay: ${idx * 0.1}s">
                <!-- Image Section -->
                <div class="relative h-64 overflow-hidden">
                    <img src="${r.imageUrl || 'https://via.placeholder.com/600x400'}" 
                         class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105">
                    
                    <!-- Overlay Gradient -->
                    <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-80"></div>
                    
                    <!-- Top Badges -->
                    <div class="absolute top-4 left-4 right-4 flex justify-between items-start">
                        <span class="px-3 py-1.5 bg-white/20 backdrop-blur-md border border-white/20 rounded-xl text-xs font-bold text-white flex items-center gap-1.5">
                            <i class="fas fa-utensils text-xs"></i> ${r.category}
                        </span>
                        <div class="flex items-center bg-yellow-400 text-yellow-900 px-2.5 py-1 rounded-lg text-xs font-bold shadow-lg">
                            <i class="fas fa-star text-[10px] me-1"></i> ${r.rating}
                        </div>
                    </div>

                    <!-- Bottom Info -->
                    <div class="absolute bottom-4 left-5 right-5">
                       <h3 class="font-bold text-white text-xl mb-1 leading-snug tracking-tight text-shadow-sm">${r.name}</h3>
                       <div class="flex items-center gap-4 text-white/80 text-xs font-medium">
                            <span class="flex items-center gap-1"><i class="fas fa-clock"></i> ${r.time} mins</span>
                            <span class="flex items-center gap-1"><i class="fas fa-list"></i> ${r.ingredients.length} Items</span>
                       </div>
                    </div>
                </div>

                <!-- Body Actions -->
                <div class="p-5 mt-auto bg-white border-t border-gray-50">
                    <p class="text-sm text-gray-500 line-clamp-2 mb-4 font-medium leading-relaxed">${r.desc}</p>
                    
                    <div class="grid grid-cols-2 gap-3">
                        <button onclick="editRecipe('${r.id}')" 
                                class="flex items-center justify-center gap-2 w-full py-3 bg-indigo-600 text-white rounded-xl font-bold hover:bg-indigo-700 hover:-translate-y-0.5 transition-all duration-200 shadow-md hover:shadow-lg">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                        <button onclick="deleteRecipe('${r.id}')" 
                                class="flex items-center justify-center gap-2 w-full py-3 bg-white border-2 border-red-50 text-red-500 rounded-xl font-bold hover:bg-red-50 hover:text-red-600 hover:border-red-100 transition-all duration-200" title="Delete">
                            <i class="fas fa-trash-alt"></i> Delete
                        </button>
                    </div>
                </div>
            </div>
        `).join('');
    }


    // --- Form Handling ---

    window.prepareAddRecipe = function () {
        document.getElementById('modalTitle').textContent = 'Create New Recipe';
        document.getElementById('recipeForm').reset();
        fId.value = '';

        // Clear new input
        document.getElementById('recipeCategory').value = '';

        hidePreview();

        listIngredients.innerHTML = '';
        listSteps.innerHTML = '';
        addIngredient('');
        addStep('');
    }

    // New Helper: Set Category Input
    window.setCategory = (val) => {
        document.getElementById('recipeCategory').value = val;
    };

    window.editRecipe = function (id) {
        const r = recipes.find(i => i.id === id);
        if (!r) return;

        document.getElementById('modalTitle').textContent = 'Edit Recipe';
        fId.value = r.id;
        fName.value = r.name;

        // Set text value
        document.getElementById('recipeCategory').value = r.category;

        fTime.value = r.time;
        fRating.value = r.rating;
        fDesc.value = r.desc;

        if (r.imageUrl) showPreview(r.imageUrl); else hidePreview();

        listIngredients.innerHTML = '';
        r.ingredients.forEach(i => addIngredient(i));

        listSteps.innerHTML = '';
        r.steps.forEach(s => addStep(s));

        bootstrapModal.show();
    }

    window.saveRecipe = function () {
        const id = fId.value;
        const name = fName.value;
        const time = fTime.value;
        const rating = fRating.value;
        const desc = fDesc.value;

        // Get category from INPUT
        const cat = document.getElementById('recipeCategory').value.trim() || 'General';

        // Collect Lists
        const ingredients = Array.from(listIngredients.querySelectorAll('input')).map(i => i.value).filter(v => v.trim() !== '');
        const steps = Array.from(listSteps.querySelectorAll('textarea')).map(i => i.value).filter(v => v.trim() !== '');

        if (!name) { alert('Name is required'); return; }

        let imageUrl = fImgPreview.src;
        if (fFile.files && fFile.files[0]) imageUrl = URL.createObjectURL(fFile.files[0]);
        if (fImgPreview.classList.contains('hidden') && !fFile.files[0]) imageUrl = '';

        const data = {
            id: id || Date.now().toString(),
            name, category: cat, imageUrl, time, rating, desc, ingredients, steps
        };

        if (id) {
            const idx = recipes.findIndex(r => r.id === id);
            if (idx > -1) recipes[idx] = data;
        } else {
            recipes.unshift(data);
        }

        bootstrapModal.hide();
        renderAll();
    }

    window.deleteRecipe = function (id) {
        if (!confirm('Delete this delicious recipe?')) return;
        recipes = recipes.filter(r => r.id !== id);
        renderAll();
    }


    // --- Dynamic List Logic ---

    window.addIngredient = function (value = '') {
        const div = document.createElement('div');
        div.className = 'flex gap-3 group animate-fade-in-up';
        div.innerHTML = `
            <div class="flex-grow">
                <input type="text" class="form-input-premium py-2 text-sm" value="${value}" placeholder="Add ingredient e.g. 500g Chicken">
            </div>
            <button type="button" onclick="this.parentElement.remove()" class="text-gray-300 hover:text-red-500 transition-colors p-2"><i class="fas fa-times"></i></button>
        `;
        listIngredients.appendChild(div);
    }

    window.addStep = function (value = '') {
        const div = document.createElement('div');
        div.className = 'flex gap-3 group animate-fade-in-up';
        div.innerHTML = `
            <div class="flex-grow">
                <textarea class="form-input-premium py-2 text-sm resize-none h-16" placeholder="Describe the step...">${value}</textarea>
            </div>
            <button type="button" onclick="this.parentElement.remove()" class="text-gray-300 hover:text-red-500 transition-colors p-2 mt-2"><i class="fas fa-times"></i></button>
        `;
        listSteps.appendChild(div);
    }

    // --- Helpers ---
    function showPreview(url) {
        fImgPreview.src = url;
        fImgPreview.classList.remove('hidden');
        fImgPlaceholder.classList.add('opacity-0');
        fImgPlaceholder.classList.add('hidden'); // Ensure it hides completel
    }
    function hidePreview() {
        fImgPreview.src = '';
        fImgPreview.classList.add('hidden');
        fImgPlaceholder.classList.remove('opacity-0');
        fImgPlaceholder.classList.remove('hidden');
    }

});
