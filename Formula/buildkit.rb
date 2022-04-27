class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.10.2",
      revision: "9d2c9b25145ff021f91374408be710938297ba24"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87ca3d47985bd2e2fb795bb8e895ce374d8ac338e0c362e93afff8784ccfaf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "226c6fda756c35a10b2ede60a0a0917344af2044ddce88a882fdae24f05c9da1"
    sha256 cellar: :any_skip_relocation, monterey:       "f380216274c7b4f20fb0797134925e9842ed08eca968450d6ce7187539b2672c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dfbb30874fd5bfde0c6bc21afd6a5f9f9fc38f04264d7d2c2053f97dd20de0e"
    sha256 cellar: :any_skip_relocation, catalina:       "ef5e9edf9cf5a61c8a320244b1ae043cb5c9fdea69fe85e64576b955fe1cf26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1744f82406c666a85f4f07661b2b9d1e1a074f9c1a03de9ae46beac06a4889b8"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", "-trimpath",
      "-ldflags", ldflags.join(" "), "-o", bin/"buildctl", "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)
  end
end
