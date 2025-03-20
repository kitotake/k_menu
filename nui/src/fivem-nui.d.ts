/**
 * Type definitions for FiveM NUI Environment
 */

/**
 * Returns the name of the resource that the NUI page belongs to
 */
declare function GetParentResourceName(): string;

/**
 * Sends a callback message to the game script
 * @param name The callback name to target
 * @param data The data to send with the callback
 * @param cb A function to handle the response from the game script
 */
declare function SendNuiCallback(name: string, data: any, cb: (data: any) => void): void;

/**
 * Registers a NUI callback handler
 * @param name The callback name to handle
 * @param callback The function to handle the callback
 */
declare function RegisterNuiCallbackType(name: string): void;

/**
 * Post messages to the game script
 */
interface NuiMessageData {
  [key: string]: any;
}

interface Window {
  /**
   * Sends a message to the game script
   */
  invokeNative(native: string, ...args: any[]): void;
}