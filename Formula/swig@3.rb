class SwigAT3 < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz"
  sha256 "7cf9f447ae7ed1c51722efc45e7f14418d15d7a1e143ac9f09a668999f4fc94d"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/swig@3"
    sha256 aarch64_linux: "b2662233b258388f3d0d8b2777f39b35988d965087106bc693866360b0b4a9cd"
  end

  keg_only :versioned_formula

  deprecate! date: "2022-03-01", because: :unsupported

  depends_on "pcre"

  uses_from_macos "ruby" => :test

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int add(int x, int y)
      {
        return x + y;
      }
    EOS
    (testpath/"test.i").write <<~EOS
      %module test
      %inline %{
      extern int add(int x, int y);
      %}
    EOS
    (testpath/"run.rb").write <<~EOS
      require "./test"
      puts Test.add(1, 1)
    EOS
    system "#{bin}/swig", "-ruby", "test.i"
    if OS.mac?
      system ENV.cc, "-c", "test.c"
      system ENV.cc, "-c", "test_wrap.c",
             "-I#{MacOS.sdk_path}/System/Library/Frameworks/Ruby.framework/Headers/"
      system ENV.cc, "-bundle", "-undefined", "dynamic_lookup", "test.o",
             "test_wrap.o", "-o", "test.bundle"
    else
      ruby = Formula["ruby"]
      args = Utils.safe_popen_read(
        ruby.opt_bin/"ruby", "-e", "'puts RbConfig::CONFIG[\"LIBRUBYARG\"]'"
      ).chomp
      system ENV.cc, "-c", "-fPIC", "test.c"
      system ENV.cc, "-c", "-fPIC", "test_wrap.c",
             "-I#{ruby.opt_include}/ruby-#{ruby.version.major_minor}.0",
             "-I#{ruby.opt_include}/ruby-#{ruby.version.major_minor}.0/x86_64-linux/"
      system ENV.cc, "-shared", "test.o", "test_wrap.o", "-o", "test.so",
             *args.delete("'").split
    end
    assert_equal "2", shell_output("ruby run.rb").strip
  end
end
