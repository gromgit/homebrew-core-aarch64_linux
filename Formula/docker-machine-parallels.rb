class DockerMachineParallels < Formula
  desc "Parallels Driver for Docker Machine"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels.git",
      tag:      "v2.0.1",
      revision: "a1c3d495487413bdd24a562c0edee1af1cfc2f0f"
  license "MIT"
  head "https://github.com/Parallels/docker-machine-parallels.git", branch: "master"

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "docker-machine"
  depends_on :macos

  def install
    system "make", "build"
    bin.install "bin/docker-machine-driver-parallels"
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
