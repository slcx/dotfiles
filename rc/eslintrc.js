module.exports = {
  extends: [
    'airbnb',
    'plugin:jest/recommended',
    'plugin:flowtype/recommended',
  ],

  plugins: ['jest', 'flowtype'],

  parser: 'babel-eslint',
  parserOptions: {
    ecmaVersion: 9,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },

  env: {
    es6: true,
    node: true,
    browser: true,
    'jest/globals': true,
  },

  rules: {
    'no-console': 'off',
    'no-multi-assign': 'off',
    'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    'no-sequences': 'error',
    complexity: ['warn', 10],
    'arrow-parens': ['error', 'always'],
  },
  globals: {
    WebAssembly: false,
    BigInt: false,
    URL: false,
    Atomics: false,
    SharedArrayBuffer: false,
  },
};
