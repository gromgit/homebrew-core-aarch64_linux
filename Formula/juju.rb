class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.35",
      revision: "da3416008ea4ce7851a4c967ae191a0044917024"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca2f5e1a00942a372e3ce5b237a1dc6bc890345c40d1fecc2b84ea4edf410416"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bf912cfc942848b406ba41dc675dfdf08e86da0a8b49785dce64e248c18605f"
    sha256 cellar: :any_skip_relocation, monterey:       "b3677103a612f52516ad41a770f3db5601b52c655b218cd13ff3c0fec901466f"
    sha256 cellar: :any_skip_relocation, big_sur:        "984ae41d611c8913ee5d4a72c36e220af4be0148464f37556fe74a898b464cd8"
    sha256 cellar: :any_skip_relocation, catalina:       "646e67eb894602fc344a3d93948e2c9fcbb464d5435c8818edecfb55eeddf320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3282e75314a0b07384ed19c84a4cc5038f1d98dbb19b46ee9a0452e8981d33f"
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
