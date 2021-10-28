class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.1.3/otp_src_24.1.3.tar.gz"
  sha256 "514ddb6ac8697321c1a4814bbd7ce62dc31d95b4c32fd75b87b188ed27879e40"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "46bd8026c5c219c143e2269c41eba83daadf81ab0ffc9685e112263c4c37a695"
    sha256 cellar: :any,                 arm64_big_sur:  "61112f79d1e78c566e60266976584d82e2ed2b7660afd7a90192ab66b46dbbbe"
    sha256 cellar: :any,                 monterey:       "5182deb3359dcb4cdb121ead07f2e28c1b35fc419402d96f4a6e4a895459daa8"
    sha256 cellar: :any,                 big_sur:        "03ed4af1c1bc97c136d54220138968debe8f7a16bb7d6bb889e1497f62a2aca7"
    sha256 cellar: :any,                 catalina:       "f54dec949bf8ef44580cae90f297357d285e899c61d173b92808d268bf1c6838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f35e1f1642c315ec99032c90cd83e358bf17aba1b950640c6f0d0cb124487ced"
  end

  head do
    url "https://github.com/erlang/otp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.1.3/otp_doc_html_24.1.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_24.1.3.tar.gz"
    sha256 "b7383e68525de4baa97302755cd282394ae48602eede67472fa7840ace40289f"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Build the doc chunks (manpages are also built by default)
    system "make", "docs", "DOC_TARGETS=chunks"
    system "make", "install-docs"

    doc.install resource("html")
  end

  def caveats
    <<~EOS
      Man pages can be found in:
        #{opt_lib}/erlang/man

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
    (testpath/"factorial").write <<~EOS
      #!#{bin}/escript
      %% -*- erlang -*-
      %%! -smp enable -sname factorial -mnesia debug verbose
      main([String]) ->
          try
              N = list_to_integer(String),
              F = fac(N),
              io:format("factorial ~w = ~w\n", [N,F])
          catch
              _:_ ->
                  usage()
          end;
      main(_) ->
          usage().

      usage() ->
          io:format("usage: factorial integer\n").

      fac(0) -> 1;
      fac(N) -> N * fac(N-1).
    EOS
    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output("./factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output("./factorial 42")
  end
end
