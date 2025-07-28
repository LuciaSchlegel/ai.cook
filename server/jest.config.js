const { createDefaultPreset } = require("ts-jest");

const tsJestTransformCfg = createDefaultPreset().transform;

/** @type {import("jest").Config} **/
module.exports = {
  testEnvironment: "node",
  transform: {
    ...tsJestTransformCfg,
  },
  testTimeout: 15000, // 15 second global timeout
  forceExit: true, // Force Jest to exit after tests complete
  detectOpenHandles: true, // Help detect hanging handles
};