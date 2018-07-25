module.exports = {
  extends: [
    'standard',
    'plugin:react/recommended',
    'plugin:jest/recommended',
  ],

  plugins: [
    'react',
    'jest',
  ],

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

    'complexity': ['warn', 10],
    'comma-dangle': ['error', 'always-multiline'],
    'require-await': 'error',
    'arrow-parens': ['error', 'always'],
    'prefer-const': ['error', { destructuring: 'all' }],

    'react/jsx-filename-extension': 'off',
    'react/prop-types': 'warn',
    'react/destructuring-assignment': 'off',
    'react/jsx-one-expression-per-line': 'off',
    'react/jsx-indent-props': ['warn', 'first'],
    'react/jsx-wrap-multilines': 'warn',
    'react/jsx-closing-bracket-location': ['warn', 'tag-aligned'],
    'react/jsx-tag-spacing': ['warn', {
      closingSlash: 'never',
      beforeSelfClosing: 'never',
      afterOpening: 'never',
      beforeClosing: 'allow',
    }],

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
}
