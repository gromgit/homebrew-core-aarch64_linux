class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.3.0/fish-3.3.0.tar.xz"
  sha256 "a4215e4cab2a5b101b0b8843720bda3c7eb98e8a14dca0950b8ef17e94282faa"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ca5064ddf99044b33696fc2af20532ac85669c81c5c2778208150c02cbff5f0b"
    sha256 cellar: :any, big_sur:       "14ea6ff44a9919678d7c7e8e5d84fbde30e54ce74332924b09d44db398032f21"
    sha256 cellar: :any, catalina:      "67cfaf1bc8dcbe67e25b07f3e2a042e4f56b58b9eeaa4cfd54dea1606ca05067"
    sha256 cellar: :any, mojave:        "675ffed16254d0a3283e8facef609a6368524dd82f3d67d7690f9585f4726cea"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git"

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  depends_on "ncurses"
  depends_on "pcre2"

  def install
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
