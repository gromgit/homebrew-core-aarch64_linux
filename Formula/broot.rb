class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.7.1.tar.gz"
  sha256 "cf4d3d54ca38b022ed030e859e609b80561b38653704dc62bb69d260f84a49e2"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "05dc5b609ec1f5925e957da5522b4cb793abb9b2369d8bfe8e621eb042e3daca"
    sha256 cellar: :any,                 arm64_big_sur:  "9c544e86a7a355f6a249f866c39916c39a80c7bf09d8caa4ed8e4d576c4294b0"
    sha256 cellar: :any,                 monterey:       "553c9f861ac2f726ec50152ed8d3bd12fbdfff33d60c2c00fd088f26536e75c9"
    sha256 cellar: :any,                 big_sur:        "46190bd1a7617022f3175e1cf0fb72c7e754f9e1bfe97148848e8b7eae2296e1"
    sha256 cellar: :any,                 catalina:       "9bb8b40710b75eb9cd15196c8fd005c3d2c2ff1c4d196d376ed82d7092db49ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b5e95096557d0736dba9642ed04df2463d04cef8ea8d9d201302f6f8e88ecee"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--color", "no", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
