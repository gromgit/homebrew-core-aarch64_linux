class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.5.5.tar.gz"
  sha256 "221ebf034e05ef8c06b2e2290dfb83c6f8b4b3f8a9168d6d826b87ed3c62d51a"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/croc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "835bab5e0f32c1dcffedcd62a3535d75ea589c0ec72141878088e6ca26a33eda"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 1

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
