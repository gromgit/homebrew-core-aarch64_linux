class Inetutils < Formula
  desc "GNU utilities for networking"
  homepage "https://www.gnu.org/software/inetutils/"
  url "https://ftp.gnu.org/gnu/inetutils/inetutils-2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/inetutils/inetutils-2.1.tar.xz"
  sha256 "01b9a4bc73a47e63f6e8a07b76122d9ad2a2e46ebf14870e9c91d660b5647a22"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "4a8140152f9835c3514bc2b6611bcbc9538b8f1cad934293391a4eeec6d6e805"
    sha256 big_sur:       "f6d9546c6db38817ce79a2f1501bc5aa08f776405bba44e69ec7735f162f03bc"
    sha256 catalina:      "ebf5775904960cad8ee453c70a7fda0a08cbf7e3d40246a6314a728a12f560bc"
    sha256 mojave:        "81eb41d9e9e7417d22b81a82833de89e8f7fc4e1fa4251def162c88325824fc5"
    sha256 x86_64_linux:  "dc846ec369403d37b0355ebb8ba7199a50f0215b88b098472ece04eee19aacaa"
  end

  depends_on "libidn"

  conflicts_with "telnet", because: "both install `telnet` binaries"
  conflicts_with "tnftp", because: "both install `ftp` binaries"

  def noshadow
    # List of binaries that do not shadow macOS utils
    list = %w[dnsdomainname rcp rexec rlogin rsh]
    list += %w[ftp telnet] if MacOS.version >= :high_sierra
    list
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-idn
    ]

    on_macos do
      args << "--program-prefix=g"
    end
    system "./configure", *args
    system "make", "SUIDMODE=", "install"

    on_macos do
      # Binaries not shadowing macOS utils symlinked without 'g' prefix
      noshadow.each do |cmd|
        bin.install_symlink "g#{cmd}" => cmd
        man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
      end

      # Symlink commands without 'g' prefix into libexec/gnubin and
      # man pages into libexec/gnuman
      bin.find.each do |path|
        next if !File.executable?(path) || File.directory?(path)

        cmd = path.basename.to_s.sub(/^g/, "")
        (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
        (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}.1" => "#{cmd}.1"
      end
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    <<~EOS
      The following commands have been installed with the prefix 'g'.

          #{noshadow.sort.join("\n    ")}

      If you really need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    on_macos do
      output = pipe_output("#{libexec}/gnubin/ftp -v",
                         "open ftp.gnu.org\nanonymous\nls\nquit\n")
      assert_match "Connected to ftp.gnu.org.\n220 GNU FTP server ready", output
    end
    on_linux do
      output = pipe_output("#{bin}/ftp -v",
                         "open ftp.gnu.org\nanonymous\nls\nquit\n")
      assert_match "Connected to ftp.gnu.org.\n220 GNU FTP server ready", output
    end
  end
end
