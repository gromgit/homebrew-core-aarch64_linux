class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.9.2.0.tar.gz"
  sha256 "363db72af8fffba764b775c872b0749d052805b893b07888168f59a841e9dddd"

  bottle do
    sha256 "14e7c8e7cdec7dce8de18d5aa0a651b67aef5891ab82ed5feffc0e93768b4c8e" => :catalina
    sha256 "cdb4b89814cbc5f59cfe0ea536a29a8e93d13abeb727f78a829c7e44b00ebb34" => :mojave
    sha256 "9d5d57b1f781d6cda6a4358be131244eeb292158cba2af1ab50e4b1408ddedd1" => :high_sierra
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.9.2.1.tar.gz"
    sha256 "250b99b53dd413172db944b31c1b930aa145ac79fe6c5d7e6869ef804228c539"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.6.1.0.tar.gz"
    sha256 "a24c76f097ff44fe50b63b89bcde5d6ba9a481aecddbe88ee01b0e5a7b314556"
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }
    build_dir = buildpath/"build"

    cd "skalibs" do
      system "./configure", "--disable-shared", "--prefix=#{build_dir}", "--libdir=#{build_dir}/lib"
      system "make", "install"
    end

    cd "execline" do
      system "./configure",
        "--prefix=#{build_dir}",
        "--bindir=#{libexec}/execline",
        "--with-include=#{build_dir}/include",
        "--with-lib=#{build_dir}/lib",
        "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
        "--disable-shared"
      system "make", "install"
    end

    system "./configure",
      "--prefix=#{prefix}",
      "--libdir=#{build_dir}/lib",
      "--includedir=#{build_dir}/include",
      "--with-include=#{build_dir}/include",
      "--with-lib=#{build_dir}/lib",
      "--with-lib=#{build_dir}/lib/execline",
      "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
      "--disable-static",
      "--disable-shared"
    system "make", "install"

    # Some S6 tools expect execline binaries to be on the path
    bin.env_script_all_files(libexec/"bin", :PATH => "#{libexec}/execline:$PATH")
    sbin.env_script_all_files(libexec/"sbin", :PATH => "#{libexec}/execline:$PATH")
    (bin/"execlineb").write_env_script libexec/"execline/execlineb", :PATH => "#{libexec}/execline:$PATH"
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")

    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
