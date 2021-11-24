class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.21.1",
      revision: "7fc6f935fc27228593532c3a5ec61897c8051fff"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbe253f9aed74cbf837e86335a43e74639e3bb46d089d396500814c39f3b51d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9b16790f730787e96bee8dd81d6230af21479f4eeb83db3f5db3adb598c9ed1"
    sha256 cellar: :any_skip_relocation, monterey:       "38e3353812c53275fb7dceb31ea59aa7cba2b77bacb323e981a5213a81956fa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "53fe6209a9a4efe9cc49c0ddeebd4de9a7dafca4d542c9fa14a7eaf27aa1f37a"
    sha256 cellar: :any_skip_relocation, catalina:       "e3dca44d74a6c66d6a29ce01a68e0ed978a1627e4c9d3bd2119d3413d0a8e57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23234ecfeb4b72acc5306a6ebc053d0035540a2daae5ae8bcc7beba766552a8"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calicoctl/v3/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
