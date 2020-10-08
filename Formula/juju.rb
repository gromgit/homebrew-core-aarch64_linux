class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
    tag:      "juju-2.8.5",
    revision: "1f35f6a20b57aefb350f04ae74e83ace32c73094"
  license "AGPL-3.0"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "737be2004b8ae18af75374dd8f82aa159ed883a94aaf9886a3e4609d83fde40f" => :catalina
    sha256 "ad1b91396b88142b5b1c342b9b1c5c45aaee586d3181913e124357be89c0b14f" => :mojave
    sha256 "f2e0f391df12b0be322aa9b6ea50be14cc19a3d46e49abad0c35b4dcf428d3c9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    git_commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{git_commit}
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
