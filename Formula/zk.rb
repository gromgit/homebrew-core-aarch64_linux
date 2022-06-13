class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "57dd9e9bf1f93e9a5e3d2ed94ebb1477dda2f0cd62004964a3c8ea9767ce51fd"
  license "GPL-3.0-only"
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/zk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "078d4609a9224000d523a509ac876deed73cb19dcd42e5da2246d5014cd3b443"
  end

  depends_on "go" => :build

  depends_on "icu4c"
  uses_from_macos "sqlite"

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.Version=#{version} -X=main.Build=#{tap.user}"), "-tags", "fts5,icu"
  end

  test do
    system "#{bin}/zk", "init", "--no-input"
    system "#{bin}/zk", "index", "--no-input"
    (testpath/"testnote.md").write "note content"
    (testpath/"anothernote.md").write "todolist"

    output = pipe_output("#{bin}/zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end
