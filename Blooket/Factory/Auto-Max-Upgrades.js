/**
 * @license AGPL-3.0
 * Website Cheats
 * 
 * This script is a modified version of Blooket Cheats by 05Konz.
 * Original source: https://github.com/Blooket-Council/Blooket-Cheats
 * 
 * Modifications made by bloxithic
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

(() => {
    const getStateNode = (r = document.querySelector("body>div")) => {
        const val = Object.values(r)[1];
        return val?.children?.[0]?._owner?.stateNode ? val.children[0]._owner.stateNode : getStateNode(r.querySelector(":scope>div"));
    };

    try {
        const stateNode = getStateNode();

        const maxBlooks = () => {
            stateNode.state.blooks.forEach(b => b.level = 4);
            stateNode.forceUpdate?.();
        };

        // Initial upgrade
        maxBlooks();

        // Hook into setState to auto-upgrade new blooks
        const originalSetState = stateNode.setState.bind(stateNode);
        stateNode.setState = (newState, ...rest) => {
            if (newState?.blooks) {
                newState.blooks.forEach(b => b.level = 4);
            }
            return originalSetState(newState, ...rest);
        };
    } catch (err) {
        alert("Failed to upgrade all blooks to max.");
        return;
    }
})();
