// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Linux Foundation
//
// Otterdog settings for the lfit-otterdoc-poc GitHub organization.
//
// This file is the source of truth for the organization: its settings,
// teams, repositories and branch rules. To change anything, open a pull
// request. The Otterdog webapp posts a plan showing what would change on
// GitHub, and applies it when the pull request merges.
//
// It builds on the LF-wide defaults from the central otterdog-config
// repository. Only what is specific to this organization is listed here;
// everything else comes from the defaults. Otterdog vendors the defaults
// into otterdog/vendor/ when it runs, which is why the import path below
// starts with vendor/.
//
// Every repository in the organization must appear in `_repositories`.
// Otterdog treats this list as the complete desired state: a repository
// that exists on GitHub but is missing here shows up in the plan as a
// removal, and apply DELETES it, contents included. Never remove an
// entry to "stop managing" a repository; archive it instead, or set
// `archived: true` here.
//
// Reference for every key:
// https://otterdog.readthedocs.io/en/latest/reference/organization/

local orgs = import 'vendor/otterdog-config/templates/lf-defaults.libsonnet';

// Members of both teams below. Kept in one place so they cannot drift.
local relengMembers = [
  'ModeSevenIndustrialSolutions',
  'askb',
  'eb-oss',
  'tykeal',
  'vvalderrv',
];

orgs.newOrg('lfit-otterdoc-poc') {
  settings+: {
    name: 'LF Release Engineering Otterdoc POC',
    description: 'Proof of concept for managing LF GitHub organizations with Otterdog',
    billing_email: 'agrimberg@linuxfoundation.org',
  },

  teams+: [
    orgs.newTeam('Release Engineering') {
      description: 'LF Release Engineering',
      privacy: 'visible',
      members: relengMembers,
    },
    // The Otterdog webapp lets members of this team approve Otterdog
    // pull requests and run `/otterdog apply`. The team name matches
    // the webapp's GITHUB_ADMIN_TEAMS setting.
    orgs.newTeam('otterdog-admins') {
      description: 'May approve and apply Otterdog changes in this organization',
      privacy: 'visible',
      members: relengMembers,
    },
  ],

  _repositories+:: [
    // The two repositories Otterdog itself depends on. Merge commits
    // stay allowed so pull requests can land as the single commits the
    // org commit standards require.
    orgs.newRepo('.otterdog') {
      description: 'Otterdog settings for this organization',
      allow_merge_commit: true,
      delete_branch_on_merge: false,
    },
    orgs.newRepo('otterdog-config') {
      description: 'Central Otterdog configuration and LF-wide defaults',
      allow_merge_commit: true,
      delete_branch_on_merge: false,
    },

    // Scratch repositories for testing Otterdog changes.
    orgs.newRepo('otterdog-test-repo') {
      description: 'Otterdog POC test repository',
      private: true,
    },
    orgs.newRepo('otterdog-test-repo-2') {
      description: 'Otterdog POC test repository 2',
      private: true,
    },
  ],
}
