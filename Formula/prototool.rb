class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.10.0.tar.gz"
  sha256 "5b516418f41f7283a405bf4a8feb2c7034d9f3d8c292b2caaebcd218581d2de4"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/prototool"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4d69b938b5eb105514709012aa74dfa520dbfd3211a8111618c16379a511d910"
  end

  depends_on "go" => :build

  def install
    system "make", "brewgen"
    cd "brew" do
      bin.install "bin/prototool"
      bash_completion.install "etc/bash_completion.d/prototool"
      zsh_completion.install "etc/zsh/site-functions/_prototool"
      man1.install Dir["share/man/man1/*.1"]
      prefix.install_metafiles
    end
  end

  test do
    system bin/"prototool", "config", "init"
    assert_predicate testpath/"prototool.yaml", :exist?
  end
end
