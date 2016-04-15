class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.9.5-cutoff.tar.gz"
  sha256 "d521943873665d863a207c93557dc322c091e22a4293df4e3b86eb298ebbda7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "25b74ad329b7ebf6f49220281503081ba374bb136948a1dc1817a03ebef09608" => :el_capitan
    sha256 "9c1cf115a4fa83bd6d4f3d161b2290ac5416751850dd882ac5b06c21a2d9a884" => :yosemite
    sha256 "db6c54af16bfb881914e38ef90d2ce906a64c6f210a90ed03279c66c6e396a05" => :mavericks
  end

  depends_on :ant => :build
  depends_on :java => "1.7+"

  def install
    args = []
    # ant on ML and below is too old to support 1.8
    args << "-Dbuild.compiler=javac1.7" if MacOS.version < :mavericks
    system "ant", *args
    libexec.install %w[bin lib dist contrib]
    libexec.install "config" => "config-examples"
    (libexec/"config").mkpath

    # Write shim scripts for all utilities
    bin.write_exec_script Dir["#{libexec}/bin/*.sh"]
  end

  def caveats; <<-EOS.undent
    You will need to set VOLDEMORT_HOME to:
      #{libexec}

    Config files should be placed in:
      #{libexec}/config
    or you can set VOL_CONF_DIR to a more reasonable path.
    EOS
  end

  test do
    ENV["VOLDEMORT_HOME"] = libexec
    system "#{bin}/vadmin.sh"
  end
end
