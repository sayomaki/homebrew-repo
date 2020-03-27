class Steghide < Formula
  desc "Steganography program able to hide data in image and audio files"
  homepage "https://steghide.sourceforge.io"
  url "https://downloads.sourceforge.net/project/steghide/steghide/0.5.1/steghide-0.5.1.tar.gz"
  sha256 "78069b7cfe9d1f5348ae43f918f06f91d783c2b3ff25af021e6a312cf541b47b"

  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "mcrypt"
  depends_on "mhash"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-repo"
    sha256 "c26eb094300d208d478868e21ce799a64fb372cfea77e7c4a0bb08bb06337b62" => :mojave
  end

  patch do
    url "https://raw.githubusercontent.com/willi123yao/brew-repo/a415d8e1ceb8a9b9ed5211f83ac354f4f47b0216/Patches/steghide-gcc.diff"
    sha256 "75fd41eeecdf5446d5d693fefc651ba3429c70e3133fbb2c0b0d78615ccbdaf0"
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    inreplace "src/Makefile", "SHELL = /bin/sh", "SHELL = /bin/bash"
    inreplace "src/Makefile", "LIBTOOL = $(SHELL) libtool", "LIBTOOL = $(SHELL) glibtool --tag CXX"
    system "make", "install"
  end

  test do
    system bin/"steghide", "--version"
  end
end
