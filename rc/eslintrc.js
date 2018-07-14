'use strict';

module.exports = {
  extends: 'airbnb',
  parser: 'babel-eslint',
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  env: {
    es6: true,
    node: true,
    browser: true,
  },
  rules: {
    'strict': ['error', 'global'],
    'no-bitwise': 'off',
    'no-iterator': 'off',
    'global-require': 'off',
    'quote-props': ['error', 'consistent-as-needed'],
    'brace-style': ['error', '1tbs', { allowSingleLine: false }],
    'curly': ['error', 'all'],
    'no-param-reassign': 'off',
    'no-console': 'off',
    'arrow-parens': ['error', 'always'],
    'no-multi-assign': 'off',
    'no-underscore-dangle': 'off',
    'no-restricted-syntax': 'off',
    'no-plusplus': 'off',
    'no-continue': 'off',
    'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    'object-curly-newline': 'off',
    'prefer-const': ['error', { destructuring: 'all' }],
    'class-methods-use-this': 'off',

    'react/jsx-filename-extension': 'off',
    'react/prop-types': 'warn',
    'react/destructuring-assignment': 'off',
    'react/jsx-one-expression-per-line': 'off',
    'react/jsx-wrap-multilines': 'off',
    'react/jsx-indent-props': ['warn', 'first'],
    'react/jsx-closing-bracket-location': ['warn', 'tag-aligned'],

    'import/no-dynamic-require': 'off',
    'import/no-extraneous-dependencies': ['error', {
      devDependencies: true,
    }],
    'import/extensions': 'off',
  },
  globals: {
    WebAssembly: false,
    BigInt: false,
    URL: false,
    Atomics: false,
    SharedArrayBuffer: false,
  },
};
