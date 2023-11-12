import * as Y from 'yjs';
import { IAwareness } from './tokens';
/**
 * Default user implementation.
 */
export declare class AwarenessMock implements IAwareness {
    constructor(doc: Y.Doc);
    setLocalState(state: any): void;
    setLocalStateField(field: string, value: any): void;
    getLocalState(): any;
    getStates(): any;
    on(name: string, f: any): void;
    off(name: string, f: any): void;
    once(name: string, f: any): void;
    emit(name: string, args: any): void;
    destroy(): void;
    doc: Y.Doc;
    clientID: number;
    states: Map<any, any>;
    meta: Map<any, any>;
    _checkInterval: any;
    _observers: any;
}
