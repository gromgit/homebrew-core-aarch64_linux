class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.35.2.tar.xz"
  sha256 "c73d0c4fa5dcebdb2ccc293900952351cc5fb89224bb133c116305f45ae600f3"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52237b2976887bbf7b3af909acc446e21af65cd8f0f4b152f19fe28d54cd43de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9888ec473be2d4423f508a30826445782d016dea087f3b83a4c8333e9b1e9051"
    sha256 cellar: :any_skip_relocation, monterey:       "52237b2976887bbf7b3af909acc446e21af65cd8f0f4b152f19fe28d54cd43de"
    sha256 cellar: :any_skip_relocation, big_sur:        "9888ec473be2d4423f508a30826445782d016dea087f3b83a4c8333e9b1e9051"
    sha256 cellar: :any_skip_relocation, catalina:       "1e931f34d1823eca1b8474c44cec5035faae3d9d5e7855eadf98826c5f367bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53c38906cc2772426cb4585e63b4de9047bc909232f7823d0b22caebb927c7b3"
  end

  depends_on "git"
  depends_on "subversion"

  uses_from_macos "perl"

  def install
    perl = DevelopmentTools.locate("perl")
    perl_version, perl_short_version = Utils.safe_popen_read(perl, "-e", "print $^V")
                                            .match(/v((\d+\.\d+)(?:\.\d+)?)/).captures

    ENV["PERL_PATH"] = perl
    ENV["PERLLIB_EXTRA"] = Formula["subversion"].opt_lib/"perl5/site_perl"/perl_version/"darwin-thread-multi-2level"
    if OS.mac?
      ENV["PERLLIB_EXTRA"] += ":" + %W[
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      ].uniq.map do |p|
        "#{p}/Library/Perl/#{perl_short_version}/darwin-thread-multi-2level"
      end.join(":")
    end

    args = %W[
      prefix=#{prefix}
      perllibdir=#{Formula["git"].opt_share}/perl5
      SCRIPT_PERL=git-svn.perl
    ]

    mkdir libexec/"git-core"
    system "make", "install-perl-script", *args

    bin.install_symlink libexec/"git-core/git-svn"
  end

  test do
    system "svnadmin", "create", "repo"

    url = "file://#{testpath}/repo"
    text = "I am the text."
    log = "Initial commit"

    system "svn", "checkout", url, "svn-work"
    (testpath/"svn-work").cd do |current|
      (current/"text").write text
      system "svn", "add", "text"
      system "svn", "commit", "-m", log
    end

    system "git", "svn", "clone", url, "git-work"
    (testpath/"git-work").cd do |current|
      assert_equal text, (current/"text").read
      assert_match log, pipe_output("git log --oneline")
    end
  end
end
