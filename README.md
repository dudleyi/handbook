# D's FreeBSD Handbook (DFBH)

This script enables users to access, navigate, and view the authoritative FreeBSD Handbook offline, seamlessly supporting both terminal and graphical sessions.

## Core Principles
1. Avoid external dependencies.
2. Keep the script simple and intuitive.

## Features
1. **Symlink Creation:** On the first run, the script creates a `~/handbook` folder and symlinks the FreeBSD Handbook for easy future access.
2. **File Execution (-F Flag):** Use the `-F` flag to pass a specific file name as a command for quick access.
3. **Environment-Friendly:** Only relies on the `BROWSER` variable for viewing, avoiding tools like `xdg-open`.
4. **Content Scrubbing:** Removes unnecessary elements (e.g., repetitive menus) for cleaner display in terminal sessions.
5. **Search Capability:** Includes a simple search function with optional case sensitivity.

## Usage Examples
1. **View Handbook:**
   ```sh
   handbook
   ```
2. **Search Handbook:**
   ```sh
   handbook -s "keyword"
   ```
3. **Open Specific File:**
   ```sh
   handbook -F filename
   ```

## Compatibility
- Tested on FreeBSD (version 14.2) but I do not see why it could not work on older versions.
- Works in both terminal and graphical environments.

## Notes
- No external dependencies are required; uses native FreeBSD tools.
- Defaults to `~/handbook` for symlink creation, but you can configure this in the script settings.
- Check the screenshot folder. My terminal is set to that theme. Yours may look different.

--- 

- Dudley