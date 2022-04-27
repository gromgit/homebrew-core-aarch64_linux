class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.29",
      revision: "2ad800a0f8585e139eff34a1e214aac2da8e7073"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc41dab8cbf87b7111fed27a73bab0b85f9ee8643c7ec487b53c3ab571c04020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b5f2083f20f930ff2aeb4ae2d919c1abec92d87b5704d27c57a2e2ef6618aba"
    sha256 cellar: :any_skip_relocation, monterey:       "5d64838360697aafd7a1384a2639eb55a2ffc6ee90fd86416fe8d4041ac42f20"
    sha256 cellar: :any_skip_relocation, big_sur:        "183012f86b1a3ad56a8ae1e4e43c5f68a4786c54b0cd27413d65a39e874b01cd"
    sha256 cellar: :any_skip_relocation, catalina:       "026d912ffa107a5fad8c843031ba63d6a8880b3aad873a342aadbde4b0c2d235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2cae3384ed52c29e56d21519e357391b3c927d76f2439ecd46729de7ded417"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ld_flags), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: ld_flags), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
