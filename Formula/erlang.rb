class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.1.6/otp_src_24.1.6.tar.gz"
  sha256 "908883548f6132916f381f9442c7d4bd7bb92d5e5bbf22aa99b8a02ef8a1ec60"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a69e8de72b751a141dc290599d65bc08519db780b9dbf6c9f6998a290bfccaaf"
    sha256 cellar: :any,                 arm64_big_sur:  "8344869e45fb3d3bfa2bb55b55ce7446963cd44f6b506358371b145d9ae678c2"
    sha256 cellar: :any,                 monterey:       "0b25b23309f06b88ea5cefeffd6fa0be5fad8d8fa2e64f736dcc8b0c2227d542"
    sha256 cellar: :any,                 big_sur:        "824a9ec12c103f9d3fc259f27cabb0dae9a7157238dca72260273e78a0d565bd"
    sha256 cellar: :any,                 catalina:       "24fb810fd940af0a9534e1b7f1ecaa231bc13032463ff2e525b90895bc827553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a37db47c9e140275ae0a09a90203c35e3a2dd39107286a74a118b1195f4c3fa"
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
    url "https://github.com/erlang/otp/releases/download/OTP-24.1.6/otp_doc_html_24.1.6.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_24.1.6.tar.gz"
    sha256 "2b96a49b30f0402681acd8522d7cec6530d9b40c28067005d9bc633125ea7135"
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
