class Stegsnow < Formula
  desc "Used to conceal messages in ASCII text by appending whitespace"
  homepage "http://www.darkside.com.au/snow"
  url "http://www.darkside.com.au/snow/snow-20130616.tar.gz", user_agent: :fake
  sha256 "c0b71aa74ed628d121f81b1cd4ae07c2842c41cfbdf639b50291fc527c213865"

  bottle do
    root_url "https://rawcdn.githack.com/willi123yao/brew-repo/master/Bottles"
    cellar :any_skip_relocation
    sha256 "8068acee1ff3d3a254a364b4ed38a545766202cf9cc480ba0ee5dc96b0d67e6b" => :mojave
  end

  patch do
    url "https://aur.archlinux.org/cgit/aur.git/plain/stegsnow.patch?h=stegsnow"
    sha256 "d27d97a950a99f649b705d03ef334fa33bfb76280cb6fcf21a73ad4c0fdcaafc"
  end

  def install
    system "make"
    bin.install "stegsnow"
  end

  test do
    system bin/"stegsnow", "--version"
  end
end
