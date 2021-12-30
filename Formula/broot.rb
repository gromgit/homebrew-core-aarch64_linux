class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.8.1.tar.gz"
  sha256 "c806130c4982b064ccaa7fec79436af71d4cf06ace33c2cb34d4d30b3c1095e7"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "581478c1de890ab02d2862934bc563442dd40dc9264a3a61c6f511058d98a4c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f0ceaed6896d1f754f840773cbbdb83f96753ea8f2278b5e7683470ceb698c8"
    sha256 cellar: :any_skip_relocation, monterey:       "314f17cbd7f2bdc5e1530e822e698c7e15f9198f275cc709a7dabf39fbadc583"
    sha256 cellar: :any_skip_relocation, big_sur:        "419354c6cec012c61a6fcb40f9c75632b06450cd939541bd3e18e16b0f503bbd"
    sha256 cellar: :any_skip_relocation, catalina:       "a5989df5d1726cd4053150cc401f620e2b6e100fa4a897a9984a7e8ded6fbe5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c0c5cf02ce2df1b7e14e6d9883a359bb6ac9b81445695a7859a7b26956c9e4b"
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
