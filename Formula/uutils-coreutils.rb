class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.9.tar.gz"
  sha256 "eba8b545eb495757980c1599e9aca0e8df231856afce03586cb86e69edd993b4"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5939867a6cf8dd90d542489ed05b028e00f744984ce862987b2b7c4ecd1b096"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14cc13876964e1f87e48db578e6153b0b6f701f6ddf529038193a0d1e8cfc4c9"
    sha256 cellar: :any_skip_relocation, monterey:       "96f5cbcae3bbce626796007ff20bafeb5af7a47fcaf3e54bdb37bfc51d5c84b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "067313e1dd4e6bb488eb2a58671503f7a3dc2ae5879d74f89c47c44c1674998d"
    sha256 cellar: :any_skip_relocation, catalina:       "71bf2e1dc9dc4d63cb2394a2ba75837ed3ca28ce439fc9f5cd5b429e04de5719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0536f107e74b972277e57cc8ded93bc9a5b0d84d78fbf5128c24bcb3a932a70"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
  conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
  conflicts_with "truncate", because: "both install `truncate` binaries"

  # build patch for `failed to select a version for the requirement `uu_stdbuf = "^0.0.8"``
  # remove in next release
  patch do
    url "https://github.com/uutils/coreutils/commit/c5e2515833f8eefc12fe65f0a3ffba7cbfea0ff9.patch?full_index=1"
    sha256 "e3ca918c02bbb22e280739e80933353c74af8aec54887f0b4343082c4f19dea2"
  end

  def install
    man1.mkpath

    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"

    system "make", "install",
           "PROG_PREFIX=u",
           "PREFIX=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"

    # Symlink all commands into libexec/uubin without the 'u' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"uubin").install_symlink bin/"u#{cmd}" => cmd
    end

    # Symlink all man(1) pages into libexec/uuman without the 'u' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"uuman"/"man1").install_symlink man1/"u#{cmd}" => cmd
    end

    libexec.install_symlink "uuman" => "man"

    # Symlink non-conflicting binaries
    %w[
      base32 dircolors factor hashsum hostid nproc numfmt pinky ptx realpath
      shred shuf stdbuf tac timeout truncate
    ].each do |cmd|
      bin.install_symlink "u#{cmd}" => cmd
      man1.install_symlink "u#{cmd}.1.gz" => "#{cmd}.1.gz"
    end
  end

  def caveats
    <<~EOS
      Commands also provided by macOS have been installed with the prefix "u".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^u/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"uhashsum", "--sha1", "-c", "test.sha1"
    system bin/"uln", "-f", "test", "test.sha1"
  end
end
