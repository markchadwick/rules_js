import {doubleIt} from 'example/typescript/typescript_library/doubler'


export const quadIt = (n: number): number => doubleIt(doubleIt(n))
