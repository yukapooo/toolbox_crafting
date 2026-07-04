let recipes = [];
let inventory = {};
let labels = {};
let selectedRecipe = null;
let canCraft = false;

const recipeList = document.getElementById('recipeList');
const recipeTitle = document.getElementById('recipeTitle');
const recipeOutput = document.getElementById('recipeOutput');
const ingredients = document.getElementById('ingredients');

const itemImage = document.getElementById('itemImage');

const craftBtn = document.getElementById('craftBtn');

const amountInput = document.getElementById('amountInput');
const minusBtn = document.getElementById('minusBtn');
const plusBtn = document.getElementById('plusBtn');

const maxCraftable = document.getElementById('maxCraftable');

const searchInput = document.getElementById('searchInput');

window.addEventListener('message', function(event) {
    const data = event.data;
    switch (data.action) {
        case 'open':
            document.body.style.display = 'block';
            recipes = data.recipes || [];
            inventory = data.inventory || {};
            labels = data.labels || {};
            loadRecipes();
            break;
        case 'close':
            document.body.style.display = 'none';
            break;
        case 'refresh':
            recipes = data.recipes || [];
            inventory = data.inventory || {};
            labels = data.labels || labels;
            loadRecipes();
            break;
        case 'inventory':
            inventory = data.inventory || {};
            labels = data.labels || labels;
            if (selectedRecipe !== null) {
                selectRecipe(selectedRecipe);
            }
            break;
    }
});

function loadRecipes() {
    recipeList.innerHTML = '';
    const search = searchInput.value.toLowerCase();
    recipes.forEach((recipe, index) => {
        if (
            search &&
            !recipe.label.toLowerCase().includes(search)
        ) {
            return;
        }
        const div = document.createElement('div');
        div.className = 'recipe';
        div.innerHTML = recipe.label;
        div.onclick = () => {
            selectRecipe(index);
        };
        recipeList.appendChild(div);
    });

    if (recipes.length > 0) {
        selectRecipe(0);
    }
}

function selectRecipe(index) {
    selectedRecipe = index;
    document
        .querySelectorAll('.recipe')
        .forEach((e) => e.classList.remove('active'));
    const cards =
        document.querySelectorAll('.recipe');
    if (cards[index]) {
        cards[index].classList.add('active');
    }
    const recipe = recipes[index];
    if (!recipe) return;
    recipeTitle.textContent = recipe.label;
    recipeOutput.textContent =
        `作成数: x${recipe.amount}`;
    itemImage.src =
        `nui://ox_inventory/web/images/${recipe.item}.png`;
    updateIngredients();
}

function updateIngredients() {
    const recipe = recipes[selectedRecipe];
    if (!recipe) return;
    ingredients.innerHTML = '';
    const amount =
        parseInt(amountInput.value) || 1;
    let maxPossible = 99999;
    Object.entries(recipe.ingredients).forEach(
        ([item, required]) => {
            const needed =
                required * amount;
            const owned =
                inventory[item] || 0;
            const enough =
                owned >= needed;
            const possible =
                Math.floor(owned / required);
            if (possible < maxPossible) {
                maxPossible = possible;
            }
            const div =
                document.createElement('div');
            div.className = 'ingredient';
            div.innerHTML = `
                <img
                    src="nui://ox_inventory/web/images/${item}.png"
                    class="ingredient-img"
                >
                <div class="ingredient-info">
                <div class="ingredient-name">
                    ${labels[item] || item}
                </div>
                    <div
                        class="ingredient-count"
                        style="
                            color:
                            ${enough
                                ? '#22c55e'
                                : '#ef4444'};
                        "
                    >
                        所持 ${owned}
                        /
                        必要 ${needed}
                    </div>
                </div>
            `;
            ingredients.appendChild(div);
        }
    );
    if (maxPossible === 99999) {
        maxPossible = 0;
    }
    maxCraftable.textContent =
        `最大作成可能数: ${maxPossible}`;
        canCraft = maxPossible >= amount;
        craftBtn.disabled = !canCraft;
        if (canCraft) {
            craftBtn.textContent = '作成';
        } else {
            craftBtn.textContent = '素材不足';
        }
}

amountInput.addEventListener(
    'input',
    updateIngredients
);

minusBtn.addEventListener('click', () => {
    let value =
        parseInt(amountInput.value) || 1;
    value--;
    if (value < 1) value = 1;
    amountInput.value = value;
    updateIngredients();
});

plusBtn.addEventListener('click', () => {
    let value =
        parseInt(amountInput.value) || 1;
    value++;
    amountInput.value = value;
    updateIngredients();
});

craftBtn.addEventListener('click', () => {
    if (!canCraft) {
        return;
    }
    if (selectedRecipe === null) {
        return;
    }
    const amount =
        parseInt(amountInput.value) || 1;
    fetch(
        `https://${GetParentResourceName()}/craft`,
        {
            method: 'POST',
            headers: {
                'Content-Type':
                    'application/json'
            },
            body: JSON.stringify({
                recipeId:
                    selectedRecipe + 1,
                amount: amount
            })
        }
    );
});

searchInput.addEventListener(
    'input',
    loadRecipes
);

document.addEventListener(
    'keyup',
    function(event) {
        if (event.key === 'Escape') {
            fetch(
                `https://${GetParentResourceName()}/close`,
                {
                    method: 'POST',
                    headers: {
                        'Content-Type':
                            'application/json'
                    }
                }
            );
        }
    }
);