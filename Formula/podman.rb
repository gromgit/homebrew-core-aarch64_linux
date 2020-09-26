class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v2.1.1.tar.gz"
  sha256 "5ebaa6e0dbd7fd1863f70d2bc71dc8a94e195c3339c17e3cac4560c9ec5747f8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9ab7f4cfc620ff7550e7e6ec2395d4cb3e474a2c2c366eda5e2353d9353dc54" => :catalina
    sha256 "1c549c4630bd81deb0ed73db2734c367db277760ae31ea4229641059de02239e" => :mojave
    sha256 "c7d8d19f0cd60d2e8faa54a2f229c1990cd857654dfc8696892dc42f4f9104ed" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "podman-remote-darwin"
    bin.install "bin/podman-remote-darwin" => "podman"

    system "make", "install-podman-remote-darwin-docs"
    man1.install Dir["docs/build/remote/darwin/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
  end

  test do
    assert_match "podman version #{version}", shell_output("#{bin}/podman -v")
    assert_match "Error: Get", shell_output("#{bin}/podman info 2>&1", 125)
  end
end
