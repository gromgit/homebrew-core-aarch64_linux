class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.34.0.tar.xz"
  sha256 "fd6cb9b26665794c61f9ca917dcf00e7c19b0c02be575ad6ba9354fa6962411f"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df25b56804f688af1749cbf7efb1c31fa997a2193b2caa8e50a3541f4068ce01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b91391132eb2aa9663bbca8633d7948b89e3569f393204603a29ca9f356fb38"
    sha256 cellar: :any_skip_relocation, monterey:       "df25b56804f688af1749cbf7efb1c31fa997a2193b2caa8e50a3541f4068ce01"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b91391132eb2aa9663bbca8633d7948b89e3569f393204603a29ca9f356fb38"
    sha256 cellar: :any_skip_relocation, catalina:       "c8c4eea1c0101f2a01f62f45caf5765b63c32be5711fd5ee1c1e627ea70dd5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa30815b4aa8471b240e20063117a8cf326ab9df45b43503fe06703029af76d0"
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
