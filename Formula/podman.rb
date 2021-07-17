class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.2.3.tar.gz"
  sha256 "ddb8a83d21d2f496512914820525b4c959ff0902d48caaf93a005854a9069b59"
  license "Apache-2.0"
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0d89840b5470832e745a68396682e3c9f74f7e65716b45fccf670552c8b1d58"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e22e0e5255fea30d84dd5294eaf136af39d5a5b45cdcb82042af4c1c9aae506"
    sha256 cellar: :any_skip_relocation, catalina:      "89784f35eec9285994a59cbc274769dcc40d116dfb2d1ed058203f300ab6120a"
    sha256 cellar: :any_skip_relocation, mojave:        "cb43afaff32582bd36cd08c7349baa3525cfb75b62361b99ba1985fa32018f29"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "qemu" if Hardware::CPU.intel?

  def install
    system "make", "podman-remote-darwin"
    bin.install "bin/darwin/podman"

    system "make", "install-podman-remote-darwin-docs"
    man1.install Dir["docs/build/remote/darwin/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
    fish_completion.install "completions/fish/podman.fish"
  end

  test do
    assert_match "podman version #{version}", shell_output("#{bin}/podman -v")
    assert_match(/Error: Cannot connect to the Podman socket/i, shell_output("#{bin}/podman info 2>&1", 125))
    if Hardware::CPU.intel?
      machineinit_output = shell_output("podman machine init --image-path fake-testimage123 fake-testvm123 2>&1", 125)
      assert_match "Error: open fake-testimage123: no such file or directory", machineinit_output
    end
  end
end
