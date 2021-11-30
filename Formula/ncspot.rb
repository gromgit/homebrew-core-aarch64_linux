class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.9.1.tar.gz"
  sha256 "19f36d621069dc207d058fc09a3d80c96b09eb9b45a1c91a69008b3e329c9aef"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a9fa5ed287e17bdd8faa571b3a58414ca1a932ff4603e2a0ed6865c1a4f87ee1"
    sha256 cellar: :any,                 arm64_big_sur:  "4bf1d73f3f43fb9cdb61ce27a3fbf92c7aad93443d048f710e9382e1e402e3ad"
    sha256 cellar: :any,                 monterey:       "80981b54a740f7f2ba14e978b4d37d63b2add59388a5add2498d2f9b13dd3742"
    sha256 cellar: :any,                 big_sur:        "ac3ea8b7c8bc0d9fc627affe953786da6a3aa95418e04d387d33aa3ef03cfb1b"
    sha256 cellar: :any,                 catalina:       "f8a791fe2c03b3139154f612f92844286f068e334227f0bd208c08de543fa0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04cda1055d7a0c55144fbad995e9eac42f24ae9b8164d4c327248f0625c834ed"
  end

  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features", "portaudio_backend,cursive/pancurses-backend,share_clipboard",
                               *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match "portaudio", shell_output("#{bin}/ncspot --help")

    # Linux CI has an issue running `script`-based testcases
    on_macos do
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "Please login to Spotify", stdout.read
    end
  end
end
