# Player Emulation Script

A comprehensive FiveM script that allows you to spawn and control an emulated player (NPC) for testing purposes. Perfect for testing scripts, scenarios, or game mechanics without needing another real player.

## Features

- **Full NPC Control**: Spawn, move, attack, and manage an AI-controlled player
- **Visual Feedback**: Real-time HP display with color gradient and current task indicator
- **Combat System**: Shoot with various weapons or attack with melee
- **Vehicle Integration**: Enter/leave vehicles seamlessly
- **Safety Features**: Toggle invincibility and ragdoll physics
- **Performance Optimized**: Minimal impact on game performance

## Installation

1. Download the script files
2. Place the `playeremulation` folder in your `resources` directory
3. Add `ensure playeremulation` to your `server.cfg`
4. Restart your server or run `refresh` and `start playeremulation`

## Commands

| Command | Description |
|---------|-------------|
| `/emuspawn` | Spawn the emulated player near you |
| `/emuwalktome` | Make the ped walk to your location |
| `/emushootatme [weapon]` | Make the ped shoot at you (optional weapon, default: pistol) |
| `/emugetincar` | Make the ped enter your vehicle |
| `/emutphere` | Teleport the ped to your location |
| `/emustop` | Stop current task and make ped stand still |
| `/emuinvicible` | Toggle ped's invincibility |
| `/emuleavecar` | Make the ped exit the vehicle |
| `/emufollowme` | Make the ped follow you continuously |
| `/emudelete` | Permanently delete the emulated ped |
| `/emumeleeme` | Make the ped attack you with melee |
| `/emusethealth <amount>` | Set the ped's health to a specific value |
| `/emuheal` | Restore the ped's health to full (200) |
| `/emuinfoshow` | Toggle HP and task display above the ped |
| `/emuragdoll` | Toggle whether the ped can ragdoll |

## Usage Examples

1. **Basic Testing**: `/emuspawn` then `/emushootatme` to test damage systems
2. **Vehicle Testing**: `/emugetincar` then `/emuleavecar` to test vehicle mechanics
3. **Combat Testing**: `/emumeleeme` for melee or `/emushootatme WEAPON_RPG` for explosives
4. **Health Testing**: `/emusethealth 50` then `/emuinfoshow` to monitor health

## Configuration

- **Model**: Currently uses `a_m_m_skater_01` (change in `client.lua` if desired)
- **Spawn Distance**: Spawns 2 units to the right (adjust in spawn command)
- **Display Update Rate**: Updates every 100ms (adjust in display thread for performance)

## Dependencies

None required - works with vanilla FiveM.

## Support

For issues or suggestions, please create an issue on the GitHub repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

- **Author**: branikdev
- **Contributors**: [Add your name here if you contribute]

---

*Made with ❤️ for the FiveM community*</content>
<parameter name="filePath">d:\txData\ESXLegacy_11E342.base\resources\[devscripts]\playeremulation\README.md