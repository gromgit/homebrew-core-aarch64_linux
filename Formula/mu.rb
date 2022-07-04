# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/v1.8.2/mu-1.8.2.tar.xz"
  sha256 "ffac259cd594a10e948f36937fa32e1307aa35259eae9b858c0b92329166533f"
  license "GPL-3.0-or-later"
  head "https://github.com/djcb/mu.git", branch: "master"

  # We restrict matching to versions with an even-numbered minor version number,
  # as an odd-numbered minor version number indicates a development version:
  # https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_monterey: "ff44965059c871cd238357ff17daa229eb7253ae3df2591e0036677b3b618d8b"
    sha256 arm64_big_sur:  "082b21bd43bc8105dd020029767b7d5787d05755c50d4de6a2683ef974548660"
    sha256 monterey:       "379e419f89621e65a0b980d5366a477dab0511bd97cbf8dd3cfd928a917ec702"
    sha256 big_sur:        "389c22480f1484c9cdb36ee55405a8d33a4b31729f0fff5afb4e130a1e6c3c5c"
    sha256 catalina:       "4491f46e21a8ee331f1dc15211289b0e8b8458faee24cdc682bc6868ae265cac"
    sha256 x86_64_linux:   "07f399a8c9a11be43a013c6f5f165eb6493ef17f76c67c54d194aa69f3f946a4"
  end

  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "xapian"

  uses_from_macos "texinfo" => :build

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "mu-repo", because: "both install `mu` binaries"

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # fix lisp file install location
    elisp.install share/"emacs/site-lisp/mu4e"
  end

  # Regression test for:
  # https://github.com/djcb/mu/issues/397
  # https://github.com/djcb/mu/issues/380
  # https://github.com/djcb/mu/issues/332
  test do
    mkdir (testpath/"cur")

    (testpath/"cur/1234567890.11111_1.host1!2,S").write <<~EOS
      From: "Road Runner" <fasterthanyou@example.com>
      To: "Wile E. Coyote" <wile@example.com>
      Date: Mon, 4 Aug 2008 11:40:49 +0200
      Message-id: <1111111111@example.com>

      Beep beep!
    EOS

    (testpath/"cur/0987654321.22222_2.host2!2,S").write <<~EOS
      From: "Wile E. Coyote" <wile@example.com>
      To: "Road Runner" <fasterthanyou@example.com>
      Date: Mon, 4 Aug 2008 12:40:49 +0200
      Message-id: <2222222222@example.com>
      References: <1111111111@example.com>

      This used to happen outdoors. It was more fun then.
    EOS

    system "#{bin}/mu", "init", "--muhome=#{testpath}", "--maildir=#{testpath}"
    system "#{bin}/mu", "index", "--muhome=#{testpath}"

    mu_find = "#{bin}/mu find --muhome=#{testpath} "
    find_message = "#{mu_find} msgid:2222222222@example.com"
    find_message_and_related = "#{mu_find} --include-related msgid:2222222222@example.com"

    assert_equal 1, shell_output(find_message).lines.count
    assert_equal 2, shell_output(find_message_and_related).lines.count, <<~EOS
      You tripped over https://github.com/djcb/mu/issues/380
        --related doesn't work. Everything else should
    EOS
  end
end
