module.exports = {
  extends: [
    'standard',
    'plugin:react/recommended',
    'plugin:jest/recommended',
    'plugin:flowtype/recommended',
  ],

  plugins: ['react', 'jest', 'flowtype'],

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

    'space-before-function-paren': 'off',
    complexity: ['warn', 10],
    'comma-dangle': ['error', 'always-multiline'],
    'require-await': 'error',
    'arrow-parens': ['error', 'always'],
    'prefer-const': ['error', { destructuring: 'all' }],

    'react/display-name': 'off',
    'react/jsx-filename-extension': 'off',
    'react/prop-types': 'warn',
    'react/destructuring-assignment': 'off',
    'react/jsx-one-expression-per-line': 'off',
    'react/jsx-indent-props': ['warn', 'first'],
    'react/jsx-wrap-multilines': 'warn',
    'react/jsx-closing-bracket-location': ['warn', 'tag-aligned'],
    'react/react-in-jsx-scope': 'off',

    'import/no-dynamic-require': 'off',
    'import/no-extraneous-dependencies': [
      'error',
      {
        devDependencies: true,
      },
    ],
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
