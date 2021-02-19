require('plenary.test_harness'):setup_busted()

-- Imports
local Group = require('colorbuddy.group').Group
local groups = require('colorbuddy.group').groups

local Color = require('colorbuddy.color').Color
local colors = require('colorbuddy.color').colors

local styles = require('colorbuddy.style').styles
local helper = require('test.helper')

describe('Real time updates', function()
    before_each(function()
        helper.clear()

        Color.new('red', '#d47d7d')
        Color.new('yellow', '#f0c674')
        Color.new('gray0', '#1d1f21')
    end)
    it('should handle a color updating', function()
        colors.red:new_child('light_red', 'light')
        assert.are.same(colors.red.H, colors.light_red.H)
        assert.are.same(colors.red.S, colors.light_red.S)
        assert.are.same(colors.red.L + 0.1, colors.light_red.L)

        -- Make a new red
        Color.new('red', '#d72819')
        assert.are.same(colors.red.H, colors.light_red.H)
        assert.are.same(colors.red.S, colors.light_red.S)
        assert.are.same(colors.red.L + 0.1, colors.light_red.L)
    end)

    it('should handle a group\'s color updating', function()
        Group.new('parent_group', colors.red, colors.gray0, styles.bold)
        Group.new('child_group', groups.parent_group, groups.parent_group.bg:dark(), styles.italic)

        assert.are.same(groups.parent_group.fg, groups.child_group.fg)
        assert.are.same(groups.parent_group.bg, groups.child_group.bg.parent)

        Color.new('gray0', '#f0c674')
        assert.are.same(groups.parent_group.bg, groups.child_group.bg.parent)
        assert.are.same(colors.gray0:dark().H, groups.child_group.bg.H)
        assert.are.same(colors.gray0:dark().S, groups.child_group.bg.S)
        assert.are.same(colors.gray0:dark().L, groups.child_group.bg.L)
    end)
end)
