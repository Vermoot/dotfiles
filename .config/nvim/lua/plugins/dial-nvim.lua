return {
  "monaqa/dial.nvim",
  lazy = true,
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          v = {
            ["+"] = {
              function() return require("dial.map").manipulate("increment", "visual") end,
              desc = "Increment",
            },
            ["-"] = {
              function() return require("dial.map").manipulate("decrement", "visual") end,
              desc = "Decrement",
            },
            ["g+"] = {
              function() return require("dial.map").manipulate("increment", "gvisual") end,
              desc = "Increment",
            },
            ["g-"] = {
              function() return require("dial.map").manipulate("decrement", "gvisual") end,
              desc = "Decrement",
            },
          },
          x = {
            ["g+"] = {
              function() return require("dial.map").manipulate("increment", "gvisual") end,
              desc = "Increment",
            },
            ["g-"] = {
              function() return require("dial.map").manipulate("decrement", "gvisual") end,
              desc = "Decrement",
            },
          },
          n = {
            ["+"] = {
              function() return require("dial.map").manipulate("increment", "normal") end,
              desc = "Increment",
            },
            ["-"] = {
              function() return require("dial.map").manipulate("decrement", "normal") end,
              desc = "Decrement",
            },
            ["g+"] = {
              function() return require("dial.map").manipulate("increment", "gnormal") end,
              desc = "Increment",
            },
            ["g-"] = {
              function() return require("dial.map").manipulate("decrement", "gnormal") end,
              desc = "Decrement",
            },
          },
        },
      },
    },
  },
  config = function()
    local augend = require "dial.augend"
    require("dial.config").augends:register_group {
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.bool,
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.semver.alias.semver,
        augend.date.new {
          pattern = "%B", -- titlecased month names
          default_kind = "day",
        },
        augend.constant.new {
          elements = {
            "january",
            "february",
            "march",
            "april",
            "may",
            "june",
            "july",
            "august",
            "september",
            "october",
            "november",
            "december",
          },
          word = true,
          cyclic = true,
        },
        augend.constant.new {
          elements = {
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
            "Sunday",
          },
          word = true,
          cyclic = true,
        },
        augend.constant.new {
          elements = {
            "monday",
            "tuesday",
            "wednesday",
            "thursday",
            "friday",
            "saturday",
            "sunday",
          },
          word = true,
          cyclic = true,
        },
        augend.constant.new {
          elements = {
            "KC_A",
            "KC_B",
            "KC_C",
            "KC_D",
            "KC_E",
            "KC_F",
            "KC_G",
            "KC_H",
            "KC_I",
            "KC_J",
            "KC_K",
            "KC_L",
            "KC_M",
            "KC_N",
            "KC_O",
            "KC_P",
            "KC_Q",
            "KC_R",
            "KC_S",
            "KC_T",
            "KC_U",
            "KC_V",
            "KC_W",
            "KC_X",
            "KC_Y",
            "KC_Z",
          },
          word = true,
          cyclic = true,
        },
        augend.constant.new {
          elements = {
            "KC_0",
            "KC_1",
            "KC_2",
            "KC_3",
            "KC_4",
            "KC_5",
            "KC_6",
            "KC_7",
            "KC_8",
            "KC_9",
          },
          word = true,
          cyclic = true,
        },
      },
    }
  end,
}
