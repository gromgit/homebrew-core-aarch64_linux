class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.8",
      revision: "f4b4ab472fc05ac58d94aa7a9110b5925709e6a2"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1942c8eb89140887e0b16a6f0351218afe539fba2628c49edefa52bfc70ecff2"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a13692404722240daa7ea5da4af3cc383935879887c50138393d194125b486f"
    sha256 cellar: :any_skip_relocation, catalina:      "001be5964d1cd763a16dcf081af890d7bd13893d408a51a0a830053dc2a86937"
    sha256 cellar: :any_skip_relocation, mojave:        "37c12fdf803f0a0a6500acdd32bb270f8d4f4711205afa136c78eaf4fe771bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c911b047e19d96d92a7547d8041e4c701ec8d6e2009fe02e9aa6e40318f8f11c"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "./cmd/juju"
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "-o", bin/"juju-metadata",
                 "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
