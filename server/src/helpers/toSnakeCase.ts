export function toSnakeCaseDeep(obj: any): any {
    if (Array.isArray(obj)) {
      return obj.map(toSnakeCaseDeep);
    } else if (obj !== null && typeof obj === 'object') {
      return Object.keys(obj).reduce((acc, key) => {
        const snakeKey = key.replace(/([A-Z])/g, '_$1').toLowerCase();
        acc[snakeKey] = toSnakeCaseDeep(obj[key]);
        return acc;
      }, {} as Record<string, any>);
    }
    return obj;
  }