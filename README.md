# 🧙‍♂️ MagicExplorer  
An action 2D game made with Godot Engine, where you play as a wizard casting spells to survive endless waves of enemies!

---

## 📜 Description

In *MagicExplorer*, you take on the role of a lone wizard, fighting off endless hordes of goblins and dangerous creatures. Armed at first with just the **Firebolt** spell, you must move swiftly, attack strategically, and defend yourself while increasing your score through kills and survival time.

Your goal is simple: **survive as long as you can and reach the highest score**!

---

## 🎮 Controls

+-------------------------------------+
| Action         | Key(s)             |
+----------------+--------------------+
| Move           | Arrow Keys or WASD |
| Cast Firebolt  | `J`                |
| Pause / Menu   | `Esc`              |
+----------------+--------------------+

---

## ✨ Features

- Score system based on kills and time
- Health system with visual heart indicators
- Firebolt magic with cooldown and directional aiming
- Multiple enemy types with different damage
- Pause menu with options and key reminders
- Pixel-art-style visuals

---

## 🛠️ Built With

- **Godot Engine 4.x**
- GDScript
- Custom PNG textures
- Modular scene architecture (player, firebolt, enemies, UI, etc.)

---

## 📂 Project Structure

res://
├── main.tscn       # Main scene
├── game.gd         # Core game logic
├── player.gd       # Player controls and spells
├── goblin.gd       # Basic enemy
├── firebolt.gd     # Spell projectile
├── UI/             # HUD, pause menu, labels
├── images/         # Sprites and textures
└── Global.gd       # Global configuration


---

## ▶️ How to Run

1. Open **Godot Engine**
2. Import the project folder
3. Run the `main.tscn` scene

---

## 📌 To-Do / Future Ideas

- Add more unlockable spells
- Boss fights
- More enemies
- Upgrade and progression system
- High score saving

---

## 🧾 License

MagicExplorer is under the MIT License.

---